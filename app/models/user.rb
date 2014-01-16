include StocksHelper

class User < ActiveRecord::Base
  has_many :ownerships
  has_many :stocks, :through => :ownerships

  has_many :buyer_transactions, :foreign_key => 'buyer_id', :class_name => 'Transaction'
  has_many :seller_transactions, :foreign_key => 'seller_id', :class_name => 'Transaction'

  def calculate_balance 
    b = 0
    b += self.seller_transactions.sum('price * amount')    
    b -= self.buyer_transactions.sum('price * amount')
    return b
  end

  # calculates and saves the current portfolio
  def update_portfolio
    buys = self.buyer_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")
    sells = self.seller_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")
    
    self.cash_in = self.seller_transactions.where("transaction_type_id = 1").sum('amount * price')
    self.investment = 0
    self.profit = 0
    self.balance = self.calculate_balance

    p = {}
    p[:stocks] = {}
    
    # go through transactions to get current portfolio  
    buys.each do |buy|
      stock = Stock.find(buy.stock_id)
      # add stocks to portfolio according to buys
      p[:stocks][buy.stock_id] = {:amount => buy.total, :stock => stock}
      sells.each do |sell|
        if buy.stock_id == sell.stock_id
          # subtract stocks from portfolio according to sells
          p[:stocks][buy.stock_id][:amount] = buy.total - sell.total
        end
      end
    end
    
    p[:stocks].each do |stock_id, data|

      # save portfolio in ownerships
      ownership = Ownership.where(:user_id => self.id, :stock_id => stock_id).first_or_create
      ownership.amount = data[:amount]

      # investment: how much did the user pay for the stocks he bought last?
      buys = self.buyer_transactions.where(:stock_id => stock_id).order('created_at DESC')      
      counter = data[:amount]
      investment = 0
      buys.each do |buy|
        if counter - buy.amount > 0
          investment += buy.price * buy.amount
        else
          investment += buy.price * counter
          break
        end
        counter -= buy.amount
      end
      ownership.investment = investment
      self.investment += investment

      # avg_price: how much did the user pay for the stocks he bought last on avg
      ownership.avg_price = (ownership.investment / ownership.amount).round(2)

      # profit: how much money did the user make trading this stock
      gains = self.seller_transactions.where(:stock_id => stock_id).sum('amount * price')
      losses = self.buyer_transactions.where(:stock_id => stock_id).sum('amount * price')      
      ownership.profit = gains - losses  
      self.profit += ownership.profit

      ownership.save
      
    end
    
    self.save
    
  end

  # retrieves the cached portfolio from db, calculates current values and formats output
  def portfolio
    
    p = {}
    
    p[:cash_in] = self.cash_in
    p[:total_investment] = self.investment
    p[:total_profit] = self.profit
    p[:balance] = self.balance
    p[:total_stocks] = 0

    # copy cached ownership info into portfolio data structure
    p[:stocks] = {}    
    Ownership.where(:user_id => self.id).each do |o|
      if o.amount.nil?
        o.amount = 0
        o.save
      end
      p[:stocks][o.stock_id] = {:amount => o.amount, :stock => o.stock, :investment => o.investment, :avg_price => o.avg_price, :profit => o.profit}
      p[:total_stocks] += o.amount
    end
    
    p[:total_value] = 0
      
    # calculate current value      
    p[:stocks].each do |stock_id, data|
      # value: how much is the stock currently worth on the market
      data[:value] = data[:amount] * data[:stock].price
      p[:total_value] += data[:value]      
    end

    # do some additional calculations
    p[:total_investment_rel] = ((self.investment / self.cash_in) * 100).round(2)
    p[:total_profit_rel] = StocksHelper.rel_percent p[:cash_in], p[:balance] 
    p[:total_value_rel] = StocksHelper.rel_percent p[:total_investment], p[:total_value] 

    return p

  end

  # user ranks for profit_abs, profit_rel, investment_abs, investment_rel
  
  # helper function to add rank to array of hashes, according to key
  def self.add_rank data, key
    sorted = data.sort_by {|item| -item[key]}
    sorted.each_with_index do |item, index|
      value = item[key]
      item[key] = {:value => item[key], :rank => index + 1} 
    end    
    return sorted
  end

  # collect all ranks for all users
  def self.all_ranks 
    data = []
    User.where("role = 'player'").each do |user|
      p = user.portfolio
      data << {  :id => user.id,
                 :name => user.name,
                 :profit_abs => p[:total_profit], 
                 :profit_rel => p[:total_profit_rel], 
                 :investment_abs => p[:total_investment], 
                 :investment_rel => p[:total_investment_rel],
                 :value_abs => p[:total_value],
                 :value_rel => p[:total_value_rel],
                 :cash_in => p[:cash_in],
                 :balance => p[:balance],
                 :num_stocks => p[:total_stocks]
               }   
    end    
    
    sort_keys = [:profit_abs, :profit_rel, :investment_abs, :investment_rel, :value_abs, :value_rel, :balance, :cash_in, :num_stocks]
    sort_keys.each { |key| data = User.add_rank data, key }
    
    data_hash = {}
    data.each do |item| 
      single_user_values = {}
      single_user_values[:name] = item[:name]
      sort_keys.each do |key| 
        single_user_values[key] = item[key]
      end
      data_hash[item[:id]] = single_user_values      
    end
    
    return data_hash
  end
  
  # extract ranks for single user
  def ranks 
    r = {}
    data_hash = User.all_ranks    
    return data_hash[self.id]
  end
  
  # add amount euros to users balance
  def add_cash(amount)
    transaction = Transaction.new
    transaction.transaction_type_id = 1
    transaction.seller_id = self.id
    transaction.price = Setting.first.exchange_rate
    transaction.amount = amount
    transaction.save
    self.update_portfolio
    return transaction
  end


  def buy_stock_from_utopist(stock, amount)

	transaction = Transaction.new
    transaction.transaction_type_id = 0
    transaction.stock_id = stock.id
    transaction.buyer_id = self.id
    transaction.seller_id = stock.utopist.id
    transaction.price = stock.base_price
    transaction.amount = amount
    transaction.save
   	transaction.update_users_stocks

  end
	


  def add_base_stocks
  
  	stocks = Stock.where(:active => true).order('investment DESC')
  	
  	[stocks[rand(8)], stocks[8 + rand(8)]].each do |stock|
		amount = (5000 / stock.base_price).to_i
		max_amount = stock.utopist.portfolio[:stocks][stock.id][:amount]
		amount = max_amount if amount > max_amount
		self.buy_stock_from_utopist(stock, amount)
  	end
  
  end






end
