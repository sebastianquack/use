class User < ActiveRecord::Base
  has_many :buyer_transactions, :foreign_key => 'buyer_id', :class_name => 'Transaction'
  has_many :seller_transactions, :foreign_key => 'seller_id', :class_name => 'Transaction'

  def balance 
    b = 0
    b += self.seller_transactions.sum('price * amount')    
    b -= self.buyer_transactions.sum('price * amount')
    return b
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
    
    
    return p

  end

  def add_cash(amount)
    transaction = Transaction.new
    transaction.transaction_type_id = 1
    transaction.seller_id = self.id
    transaction.price = Setting.first.exchange_rate
    transaction.amount = amount
    transaction.save
  end

end
