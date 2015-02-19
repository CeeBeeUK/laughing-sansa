json.array!(@events) do |event|
  json.extract! event, :id, :year, :host_city, :active, :country_id
  json.url event_url(event, format: :json)
end
