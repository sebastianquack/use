class User < ActiveRecord::Base
  has_many :buyer_transactions, :foreign_key => 'buyer_id', :class_name => 'Transaction'
  has_many :seller_transactions, :foreign_key => 'seller_id', :class_name => 'Transaction'

  def balance 
    b = 0
    b += self.seller_transactions.sum('price * amount')    
    b -= self.buyer_transactions.sum('price * amount')
    return b
  end

  # helper function for relative percentages
  def self.rel_percent x, y
    if y == x
      return 0
    end
    if y > x
      return (((y - x) / x)*100).round(2)
    else
      return -(((x - y) / x)*100).round(2)
    end
  end

  def portfolio
    buys = self.buyer_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")
    sells = self.seller_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")
    
    p = {}
    p[:stocks] = {}
    p[:cash_in] = self.seller_transactions.where("transaction_type_id = 1").sum('amount * price')
    p[:total_investment] = 0
    p[:total_value] = 0
    p[:total_profit] = 0  
    p[:balance] = self.balance
    p[:total_stocks] = 0
      
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

      p[:total_stocks] += data[:amount]

      # investment: how much did the user pay for the stocks he currently holds?
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
      data[:investment] = investment
      p[:total_investment] += investment

      # value: how much is the stock currently worth on the market
      data[:value] = data[:amount] * data[:stock].current_price
      p[:total_value] += data[:value]

      data[:avg_price] = (data[:investment] / data[:amount]).round(2)

      # profit: how much money did the user make trading this stock (todo)
      gains = self.seller_transactions.where(:stock_id => stock_id).sum('amount * price')
      losses = self.buyer_transactions.where(:stock_id => stock_id).sum('amount * price')      
      data[:profit] = gains - losses  
      p[:total_profit] += data[:profit]
      
    end
    
    p[:total_investment_rel] = ((p[:total_investment] / p[:cash_in]) * 100).round(2)
    p[:total_profit_rel] = User.rel_percent p[:cash_in], p[:balance] 
    p[:total_value_rel] = User.rel_percent p[:total_investment], p[:total_value] 

    return p

  end

  # portfolio light - for use by stock ranking via total investment
  def portfolio_light
    
    p = {}
    p[:stocks] = {}
    p[:total_investment] = 0
   
    # figure out which stocks the user currently has
    buys = self.buyer_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")
    sells = self.seller_transactions.where("transaction_type_id = 0").select("stock_id, sum(amount) as total").group("stock_id")      

    buys.each do |buy|
      # add stock amounts to portfolio according to buys
      p[:stocks][buy.stock_id] = {:amount => buy.total}
      sells.each do |sell|
        if buy.stock_id == sell.stock_id
          # subtract stocks from portfolio according to sells
          p[:stocks][buy.stock_id][:amount] = buy.total - sell.total
        end
      end
    end

    # investments: how much did the user last pay for those stocks?
    p[:stocks].each do |stock_id, data|
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
      data[:investment] = investment
      p[:total_investment] += investment
    end
    
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
  end

end
