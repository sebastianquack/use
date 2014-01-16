json.array!(@market_sessions) do |market_session|
  json.extract! market_session, :id, :duration, :max_survivors
  json.url market_session_url(market_session, format: :json)
end
