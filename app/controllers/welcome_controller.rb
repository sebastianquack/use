class WelcomeController < ApplicationController

	def index
		if(params[:id])
			@utopia = Utopia.find(params[:id])
		else 
			@utopia = Utopia.new
		end
	end

end
