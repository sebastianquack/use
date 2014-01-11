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
      portfolio = user.portfolio
      if portfolio[:stocks][self.id]
        total += portfolio[:stocks][self.id][:investment]
      end
    end
    return total
  end

  def self.investments
    inv = {}
    Stock.where("active = true").each do |stock|
      inv[stock.id] = stock.investment
    end
    
    inv_sorted_array = inv.sort_by {|key, value| -value} # we need this array because hashes cannot be sorted
    hash_out = {}
    inv_sorted_array.each_with_index do |item, index|
      hash_out[item[0]] = {:value => item[1], :rank => index + 1} # contruct output hash
    end
    return hash_out
  end

end
