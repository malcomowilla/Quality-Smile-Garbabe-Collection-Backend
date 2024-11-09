class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :date_time_of_message,
   :customer_sender_id,
  :created_at, 
  :admin_id, :customer_id, :sender_info, :conversation_id, :formatted_time


  def formatted_time
    object.date_time_of_message&.strftime("%I:%M:%S %p")
  end


  def sender_info
    if object.customer_id
      { 
        id: object.customer_id, 
        type: 'Customer',
        name: object.customer&.name || 'Unknown Customer' # Add customer name
      }
    elsif object.admin_id
      { 
        id: object.admin_id, 
        type: 'Admin',
        name: object.admin&.user_name || 'Unknown Admin' # Add admin name
      }
    end
  end
  # belongs_to :sender, only: [:id, :name]
  # belongs_to :customer_sender, only: [:id, :name]
end
