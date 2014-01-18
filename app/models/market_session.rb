class MarketSession < ActiveRecord::Base

	def self.active 
		market_session = MarketSession.order('created_at DESC').first
		return false if market_session.nil?
		return true if  market_session.created_at.to_i + market_session.duration.to_i*60 > Time.now.to_i
		return false
	end
end
