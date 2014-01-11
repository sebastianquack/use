module StocksHelper

  def rel_percent x, y
    if y == x
      return '+0.00%'
    end
    if y > x
      return '+' + ((((y - x) / x)*100).round(2)).to_s + '%'
    else
      return '-' + ((((x - y) / x)*100).round(2)).to_s + '%'
    end
  end

end
