module ChartsProcessing
	def prepare_chart_for_json(chart)
	    a = []
	    chart.each_with_index do |c,i|
	      if i >= params[:tick].to_i
	        h = c.attributes
	        h[:seconds] = c.created_at.to_i
	        h[:tick] = i
	        a << h 
	      end
	    end
	    return a
	end
end
