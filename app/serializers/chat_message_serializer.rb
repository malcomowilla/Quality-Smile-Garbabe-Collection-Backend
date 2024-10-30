class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :date_time_of_message, :sender_id,
  :formatted_date_time_of_message


  def formatted_date_time_of_message
    object.date_time_of_message.strftime('%I:%M:%S %p') if object.date_time_of_message.present?
  end

  belongs_to :sender, only: [:id, :name]
end
