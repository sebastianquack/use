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
    buys.each do |b|
      p[b.stock_id] = {:amount => b.total, :stock => Stock.find(b.stock_id)}
      sells.each do |s|
        if b.stock_id == s.stock_id
          logger.debug b.stock_id
          p[b.stock_id][:amount] = b.total - s.total
        end
      end
    end
    return p

  end


end
