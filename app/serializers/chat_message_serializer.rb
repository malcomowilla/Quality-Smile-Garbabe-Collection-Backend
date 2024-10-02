class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :date_time_of_message, :admin_id
end
