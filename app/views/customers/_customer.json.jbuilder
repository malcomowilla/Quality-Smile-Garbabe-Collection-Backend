json.extract! customer, :id, :name, :email, :phone_number, :location, :unique_identifier, :created_at, :updated_at
json.url customer_url(customer, format: :json)
