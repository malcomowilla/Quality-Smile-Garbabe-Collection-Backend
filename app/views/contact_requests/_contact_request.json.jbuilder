json.extract! contact_request, :id, :company_name, :business_type, :contact_person, :business_email, :phone_number, :expected_users, :created_at, :updated_at
json.url contact_request_url(contact_request, format: :json)
