json.extract! admin, :id, :user_name, :email, :password_digest, :phone_number, :created_at, :updated_at
json.url admin_url(admin, format: :json)
