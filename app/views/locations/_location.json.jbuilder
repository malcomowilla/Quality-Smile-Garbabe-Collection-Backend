json.extract! location, :id, :location_name, :sub_location, :location_code, :category, :created_at, :updated_at
json.url location_url(location, format: :json)
