json.extract! system_admin, :id, :user_name, :password_digest, :email, :created_at, :updated_at
json.url system_admin_url(system_admin, format: :json)
