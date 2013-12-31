class Stock < ActiveRecord::Base

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

end
