json.array!(@stocks) do |stock|
  json.extract! stock, :id, :name, :symbol, :description, :utopist, :active
  json.url stock_url(stock, format: :json)
end
