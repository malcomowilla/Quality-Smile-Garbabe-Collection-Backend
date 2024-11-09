# class MessageChannel < ApplicationCable::Channel
# #   def subscribed
    
# #     # stream_from "message_channel_#{current_customer.id}"

# #     # stream_from "message_channel_#{params[:user_id]}"
# #     # stream_for params[:receiver_id]
# #     # stream_from "current_user_#{current_user.id}"
# #         # stream_from "current_user_#{params[:receiver_id]}"
# #         # stream_from "message_channel_#{params[:room]}" 
# #     # stream_for Admin.find(params[:receiver_id])
# #     # stream_for current_user.user_name
  
# # end

#   # def receive(data)
#   #   ActionCable.server.broadcast "message_channel_#{params[:room]}", data
#   # end

#   def subscribed
#     # For customers: they see their conversation with support
#     if current_customer
#       stream_from "chat_#{current_customer.id}"
#     # For admins: they see conversations they're assigned to
#     else
#       stream_from "chat_admin_#{current_user.id}"
#     end
#   end

#   def unsubscribed
#     stop_all_streams
#   end
# end


class MessageChannel < ApplicationCable::Channel
  # def subscribed
  #   conversation_id = params[:conversation_id]
  #   stream_from "conversation_#{conversation_id}" if conversation_id
  # end

  # def receive(data)
  #   conversation_id = params[:conversation_id]
  #   message = Message.create(
  #     conversation_id: conversation_id,
  #     user_id: current_user.id,
  #     content: data['message']
  #   )
  #   ActionCable.server.broadcast("conversation_#{conversation_id}", {
  #     sender: message.sender.name,
  #     message: message.content,
  #     timestamp: message.created_at.strftime("%H:%M")
  #   })
  # end
  # 
 


  def subscribed
    if current_customer
      # Customer subscribes to their conversation
      conversation = Conversation.find_by(customer_id: current_customer.id)
      if conversation
        stream_from "conversation_#{conversation.id}"
        @subscription_identifier = "conversation_#{conversation.id}"
      end
    elsif current_user && current_user.role == "super_administrator"
      # Admin subscribes to all their conversations
      @subscription_identifiers = []
      current_user.conversations.each do |conversation|
        stream_from "conversation_#{conversation.id}"
        @subscription_identifiers << "conversation_#{conversation.id}"
      end
    end
  end



  def unsubscribed
    if @subscription_identifier
      stop_stream_from @subscription_identifier
    elsif @subscription_identifiers
      @subscription_identifiers.each do |identifier|
        stop_stream_from identifier
      end
    end
    stop_all_streams
  end

  # Optional: Add error handling
  rescue_from StandardError do |exception|
    Rails.logger.error "MessageChannel Error: #{exception.message}"
    stop_all_streams
  end
end






