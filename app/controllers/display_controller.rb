class DisplayController < ApplicationController

  layout "local"

  def projection
  	@stocks = Stock.where(:active => true);
  	@ranks = User.all_ranks
  end

  def tv
  end
end
