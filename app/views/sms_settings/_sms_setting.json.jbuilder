json.extract! sms_setting, :id, :api_key, :api_secret, :created_at, :updated_at
json.url sms_setting_url(sms_setting, format: :json)
