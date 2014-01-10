class Transaction < ActiveRecord::Base
	belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
	belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"
	belongs_to :transaction_type
	belongs_to :stock

	def usx
		return self.usx_latest_prices_sum
	end

	def usx_latest_prices_sum
		usx = []
		stocks_prices = {}
		Stock.all.each { |s| stocks_prices[s.id]=0 }
		Transaction.where(:transaction_type_id => 0).where("amount IS NOT NULL").where("stock_id IS NOT NULL").where("price IS NOT NULL").select("created_at, amount, price, stock_id").order(:created_at).each do |t|
			stocks_prices[t.stock_id] = t.price 
			usx << {:date => t.created_at, :amount => t.amount, :value => stocks_prices.values.sum}
		end
		return usx
	end

end
