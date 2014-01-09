json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :transaction_type_id, :seller_id, :buyer_id, :price, :amount, :stock_id
  json.url transaction_url(transaction, format: :json)
end
