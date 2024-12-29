# class ChatMessageSerializer < ActiveModel::Serializer
#   attributes :id, :content, :date_time_of_message,
#    :customer_sender_id,
#   :created_at, 
#   :admin_id, :customer_id, :sender_info, :conversation_id, :formatted_time, :admin_username


#   def formatted_time
#     object.date_time_of_message&.strftime("%I:%M:%S %p")
#   end


#   def sender_info
#     if object.customer_id
#       { 
#         id: object.customer_id, 
#         type: 'Customer',
#         name: object.customer&.name || 'Unknown Customer' # Add customer name
#       }
#     elsif object.admin_id
#       { 
#         id: object.admin_id, 
#         type: 'Admin',
#         name: object.admin&.user_name || 'Unknown Admin' # Add admin name
#       }
#     end
#   end
#   # belongs_to :sender, only: [:id, :name]
#   # belongs_to :customer_sender, only: [:id, :name]
# end


class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :date_time_of_message, 
             :created_at, :conversation_id, :formatted_time,
             :sender_info

  def formatted_time
    object.date_time_of_message&.strftime("%I:%M:%S %p")
  end

  def sender_info
    if object.admin_sender_id.present? # Message from admin
      { 
        id: object.admin_sender_id,  
        type: 'Admin',
        name: object.admin&.user_name || 'Unknown Admin'
      }
    elsif object.customer_sender_id.present? # Message from customer
      { 
        id: object.customer_sender_id,
        type: 'Customer',
        name: object.customer&.name || 'Unknown Customer'
      }
    else
      { 
        id: nil,
        type: 'Unknown',
        name: 'Unknown Sender' 
      }
    end
  end
end
