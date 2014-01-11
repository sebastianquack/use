class DisplayController < ApplicationController

  layout "local"

  def projection
  	@stocks = Stock.where(:active => true);
  	@top_users = User.where(:role => "player").limit(7)
  end

  def tv
  end
end
