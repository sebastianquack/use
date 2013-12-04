json.array!(@utopias) do |utopia|
  json.extract! utopia, :id, :title, :description, :realization, :risks, :effect_body, :effect_economy, :effect_politics, :effect_spirituality, :effect_technology, :effect_environment, :effect_fun, :email
  json.url utopia_url(utopia, format: :json)
end
