class Stock < ActiveRecord::Base

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

  def investment 
    total = 0
    User.where("role = 'player'").each do |user|
      portfolio = user.portfolio_light
      if portfolio[:stocks][self.id]
        total += portfolio[:stocks][self.id][:investment]
      end
    end
    return total
  end

  def self.investments
    inv = {}
    Stock.where("active = true").each do |stock|
      inv[stock.id] = {}
      inv[stock.id][:investment] = stock.investment
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
  
end
