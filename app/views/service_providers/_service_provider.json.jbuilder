json.extract! service_provider, :id, :phone_number, :name, :email, :provider_code, :status, :created_at, :updated_at
json.url service_provider_url(service_provider, format: :json)
