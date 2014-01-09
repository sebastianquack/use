json.array!(@users) do |user|
  json.extract! user, :id, :name, :balance, :type, :status
  json.url user_url(user, format: :json)
end
