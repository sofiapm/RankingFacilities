json.array!(@addresses) do |address|
  json.extract! address, :id, :location, :city, :country, :zip_code
  json.url address_url(address, format: :json)
end
