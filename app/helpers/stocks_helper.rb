module StocksHelper

  # helper function for relative percentages
  def rel_percent x, y
    if y == x
      return 0
    end
    if y > x
      return (((y - x) / x)*100).round(2)
    else
      return -(((x - y) / x)*100).round(2)
    end
  end

  def format_trend n
    if n == 0
      return '+0,00%'
    end
    if n > 0 
      return '+' + number_with_precision(n, precision: 2, separator: ',').to_s + '%'
    else
      return number_with_precision(n, precision: 2, separator: ',').to_s + '%'
    end  
  end

  def format_u n
    return number_with_precision(n, precision: 0, separator: ',', delimiter: '.')
  end

end
