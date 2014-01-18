class DisplayController < ApplicationController

  layout "local"

  def projection
  	@stocks = Stock.where(:active => true)
  	@ranks = User.all_ranks    
    @market_session = MarketSession.order('created_at DESC').first 
    @market_session_start_seconds = @market_session.created_at.to_i if !@market_session.nil?
    @market_session_end_seconds = @market_session_start_seconds + @market_session.duration * 60 if !@market_session.nil?
    if MarketSession.active
      @chart_min = @market_session_start_seconds
      @chart_max = @market_session_end_seconds
    else
      @chart_min = MarketSession.order('created_at DESC').last.created_at.to_i
      @chart_max = @market_session_end_seconds
    end
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
    @market_session = MarketSession.order('created_at DESC').first
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
