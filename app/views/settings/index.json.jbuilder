json.array!(@settings) do |setting|
  json.extract! setting, :id, :exchange_rate, :base_balance
  json.url setting_url(setting, format: :json)
end
