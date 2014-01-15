class DisplayController < ApplicationController

  layout "local"

  def projection
  	@stocks = Stock.where(:active => true)
  	@ranks = User.all_ranks
  end

  def tv
    @stocks = Stock.where(:active => true)
    @ranks = User.all_ranks
  end

  # ajax actions

  def stock_overview
    render :partial => 'stock_overview'
  end

  def top_users
  	@ranks = User.all_ranks
    render :partial => 'top_users'
  end

  def projection_scroll_1
    render :partial => 'projection_scroll_1'
  end

  def projection_scroll_2
    @stocks = Stock.where(:active => true)
    render :partial => 'projection_scroll_2'
  end
    
  def projection_scroll_3
    @stocks = Stock.where(:active => true)
    render :partial => 'projection_scroll_3'
  end
    
end
