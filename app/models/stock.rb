require 'linearregression'

class Stock < ActiveRecord::Base
  has_many :ownerships
  has_many :owners, :through => :ownerships, :source => :user

	has_many :transactions, :class_name => "Transaction", :foreign_key => "stock_id"
	belongs_to :utopist, :class_name => "User", :foreign_key => "utopist_id"

  def current_price
    return self.transactions.order("created_at").last.price
  end

  def chart
    return self.transactions.select("created_at, amount, price");
  end
  
  def price
  	return self.transactions.last.price
  end

  def next
    r = Stock.where("active = true AND id > ?", self.id).order("id ASC").first
    if r.nil?
      r = Stock.where("active = true").order("id ASC").first
    end
    return r
  end

  def previous
    r = Stock.where("active = true AND id < ?", self.id).order("id DESC").first
    if r.nil?
      r = Stock.where("active = true").order("id ASC").last
    end
    return r
  end

  def self.investments
    inv = {}
    Stock.where("active = true").each do |stock|
      inv[stock.id] = {}
      inv[stock.id][:investment] = stock.investment # this value is updated after every transaction
      inv[stock.id][:stock] = stock
    end
    
    inv_sorted_array = inv.sort_by {|key, value| -value[:investment]} # we need this array because hashes cannot be sorted
    hash_out = {}
    inv_sorted_array.each_with_index do |item, index|
      # construct output hash
      hash_out[item[0]] = {:stock => item[1][:stock], :value => item[1][:investment], :rank => index + 1} 
    end
    return hash_out
  end
  
  def rank
    ranks = Stock.investments
    return ranks[self.id]
  end
  
  def trend d = 10
    latest_transactions = self.transactions.where('created_at > ?', d.minutes.ago).order('created_at ASC')
    return 0 if latest_transactions.length < 2
    l = LinearRegression.new latest_transactions.pluck(:price) 
    return latest_transactions.first.price - l.next
  end
  
end
