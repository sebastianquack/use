class Transaction < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => "seller_id"
	belongs_to :user, :class_name => "User", :foreign_key => "buyer_id"
	belongs_to :transaction_type
	belongs_to :stock
end
