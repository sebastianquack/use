class Transaction < ActiveRecord::Base
	belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
	belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"
	belongs_to :transaction_type
	belongs_to :stock

	def self.usx
		return usx_latest_prices_sum
	end

	def self.usx_latest_prices_sum
		usx = []
		stocks_prices = {}
		Stock.all.each { |s| stocks_prices[s.id]=0 }
		Transaction.where(:transaction_type_id => 0).where("amount IS NOT NULL").where("stock_id IS NOT NULL").where("price IS NOT NULL").select("created_at, amount, price, stock_id").order(:created_at).each_with_index do |t,i|
			stocks_prices[t.stock_id] = t.price 
			usx << {:tick => i, :date => t.created_at, :seconds => t.created_at.to_i, :amount => t.amount, :value => stocks_prices.values.sum}
		end
		return usx
	end

end
