class WelcomeController < ApplicationController

	def index
		if(params[:id])
			@utopia = Utopia.find(params[:id])
		else 
			@utopia = Utopia.new
		end
	end

  def new
    @stocks = Stock.where(:active => "true")
    @stock = @stocks[0]
    
    render :layout => "layouts/application_new"    
  end

end
