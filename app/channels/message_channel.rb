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
  def subscribed
    #  Rails.logger.info "Subscribed to conversation_#{request.params[:conversation_id]}"
    # conversation_id = params[:conversation_id]
    #  conversation_id = request.params[:conversation_id]
    # stream_from "conversation_13"
    # stream_from "conversation_13" 

    # conversation_id = params[:conversation_id]
    # if conversation_id.present?
    #   Rails.logger.info "Streaming from conversation_#{conversation_id}"
    #   stream_from "conversation_13"
    # else
    #   reject
    #   Rails.logger.error "Missing conversation_id. Subscription rejected."
    # end
    # 
    #
      conversation_id = params[:conversation_id]
      stream_from "conversation_#{conversation_id.to_i}"
    # if conversation_id 
    #   stream_from "conversation_#{conversation_id.to_i}"
    # else
    #   reject
    #   Rails.logger.error "Missing conversation_id. Subscription rejected."
    # end


conversation = Conversation.find_by(id: conversation_id )
    if find_available_admin
      # stream_from "conversation_#{conversation_id.to_i}"
      ActionCable.server.broadcast("admin_notifications", {
        conversation_id: conversation_id,
        # customer_name: conversation.customer.name,
        # admin_name: find_available_admin.user_name,
        # message: conversation.chat_messages,
        # timestamp: message.created_at.strftime("%H:%M")
      })
    end
  end




  def receive(data)
    # Check if current_account is an instance of Admin or Customer
    current_user = current_account.is_a?(Admin) ? current_account : nil
    current_customer = current_account.is_a?(Customer) ? current_account : nil
  
    @conversation = if current_customer || current_user
                      Conversation.find_or_create_by(customer_id: params[:customer_id]) do |conv|
                        conv.admin_id = current_user&.id # Use current_user for admin if available
                        # conv.account_id = current_tenant.id
                      end
                    else
                      Conversation.find(params[:conversation_id])
                    end
  
    if current_user
      @message = @conversation.chat_messages.build(
        content: data['content'],
        admin_sender_id: current_user.id, # Only set admin_sender_id
        admin_id: @conversation.admin_id,
        customer_id: @conversation.customer_id,
        date_time_of_message: Time.current
      )
    elsif current_customer # Customer is sending the message
      @message = @conversation.chat_messages.build(
        content: data['content'],
        customer_sender_id: current_customer.id, # Only set customer_sender_id
        customer_id: @conversation.customer_id,
        admin_id: @conversation.admin_id,
        date_time_of_message: Time.current
      )
    end
  
    # Broadcast the message to the conversation channel
    ActionCable.server.broadcast(
      "conversation_#{ data['conversation_id'] }",
      ChatMessageSerializer.new(@message).as_json
    )
  end
  
  def unsubscribed
    current_user = current_account.is_a?(Admin) ? current_account : nil
    current_customer = current_account.is_a?(Customer) ? current_account : nil
  
    # Stop streaming from the specific conversation
    conversation_id = params[:conversation_id]
    if conversation_id.present?
      Rails.logger.info "Unsubscribed from conversation_#{conversation_id}"
      stop_stream_from "conversation_#{conversation_id}"
    else
      Rails.logger.warn "Unsubscribed without a valid conversation_id"
    end

    # Stop all streams as a fallback
    stop_all_streams
    Rails.logger.info "Stopped all streams for the user: #{current_user&.id || current_customer&.id}"
  end


  # def subscribed
  #   if current_customer
  #     # Customer subscribes to their conversation
  #     conversation = Conversation.find_by(customer_id: current_customer.id)
  #     if conversation
  #       stream_from "conversation_#{conversation.id}"
  #       @subscription_identifier = "conversation_#{conversation.id}"
  #     end
  #   elsif current_user && current_user.role == "super_administrator"
  #     # Admin subscribes to all their conversations
  #     @subscription_identifiers = []
  #     current_user.conversations.each do |conversation|
  #       stream_from "conversation_#{conversation.id}"
  #       @subscription_identifiers << "conversation_#{conversation.id}"
  #     end
  #   end
  # end



  # def unsubscribed
  #   if @subscription_identifier
  #     stop_stream_from @subscription_identifier
  #   elsif @subscription_identifiers
  #     @subscription_identifiers.each do |identifier|
  #       stop_stream_from identifier
  #     end
  #   end
  #   stop_all_streams
  # end

  # # Optional: Add error handling
  # rescue_from StandardError do |exception|
  #   Rails.logger.error "MessageChannel Error: #{exception.message}"
  #   stop_all_streams
  # end
  # 
  #
  private

  def find_available_admin
    # Use @account instead of current_tenant since you set it in set_tenant
    Admin.where(role: 'customer_support', online: true)
         .where(role: 'super_administrator', online: true)  # Use @account instead
        #  .order(Arel.sql('CASE WHEN online = true THEN 0 ELSE 1 END, conversations_count ASC'))
         .first 
  end


end






