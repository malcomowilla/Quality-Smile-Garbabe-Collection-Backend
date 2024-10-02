json.extract! chat_message, :id, :content, :date_time_of_message, :admin_id, :created_at, :updated_at
json.url chat_message_url(chat_message, format: :json)
