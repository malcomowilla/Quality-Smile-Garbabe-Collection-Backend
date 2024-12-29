json.extract! device, :id, :admin_id, :os, :ip_address, :device_token, :last_seen_at, :created_at, :updated_at
json.url device_url(device, format: :json)
