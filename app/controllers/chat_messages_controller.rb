class ChatMessagesController < ApplicationController
  # before_action :set_tenant 
  # set_current_tenant_through_filter

  # def index
  #   @messages = if current_customer
  #     ChatMessage.where(customer_id: current_customer.id)
  #   elsif current_user
  #     ChatMessage.where(admin_id: current_user.id)
  #   end.order(created_at: :asc)

  #   render json: {
  #     today: @messages.where('created_at >= ?', Time.current.beginning_of_day),
  #     yesterday: @messages.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)
  #   }
  # end
  ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do
def conversations
  conversations = if current_user.role == 'customer_support' 
    Conversation.all.includes(:customer)
  else
    Conversation.where(admin_id: current_user.id).includes(:customer)
  end



render json: conversations.as_json(
include: { customer: { only: [:id, :name, :email,  :phone_number] } },
only: [:id, :created_at, :updated_at, :conversation_id]
)

end



  def get_chat_messages
    admin = find_available_admin 


    if current_customer && find_available_offline
      render json: { 
        error: 'Support Unavailable', 
        message: 'Our customer support team is currently offline. Please try again
         later or contact us via whatsapp or email.',
        status: 'offline'
      }, status: :service_unavailable
      return
    end

    # authorize! :read, :get_chat_messages
    @conversation = if current_customer || current_user
      Conversation.find_by(customer_id: params[:customer_id])
    elsif current_user&.admin?
      Conversation.find_by(id: params[:conversation_id])
    end
  
    if @conversation
      @messages = @conversation.chat_messages.order(created_at: :asc)
      render json: {
        conversation_id: @conversation.id,
        customer_id: @conversation.customer_id,
        admin: @conversation.admin.as_json(only: [:id, :name, :online]),
        today: ActiveModel::Serializer::CollectionSerializer.new(
          @messages.where('created_at >= ?', Time.current.beginning_of_day),
          serializer: ChatMessageSerializer),
        yesterday: ActiveModel::Serializer::CollectionSerializer.new(
          @messages.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day),
          serializer: ChatMessageSerializer)
      }
    else
      # Create new conversation if customer has none
      if current_customer
        admin = find_available_admin
        @conversation = Conversation.create!(
          customer_id: params[:customer_id],
          admin_id: admin.id,
          account_id: current_tenant.id  # Add this line
        )
        render json: {
          conversation_id: @conversation.id,
          customer_id: @conversation.customer_id,
          admin: admin.as_json(only: [:id, :name, :online]),
          today: [],
          yesterday: []
        }
      else
        render json: { error: 'No conversation found' }, status: :not_found
      end
    end
  end



  





  

  def create_chat_message
    # authorize! :manage, :create_chat_message
    admin = find_available_admin 
    
    if current_customer && find_available_offline
      render json: { 
        error: 'Support Unavailable', 
        message: 'Our customer support team is currently offline. Please try again
         later or contact us via whatsapp or email.',
        status: 'offline'
      }, status: :service_unavailable
      return
    end
  

    @conversation = if current_customer || current_user
      Conversation.find_or_create_by(customer_id: params[:customer_id]) do |conv|
        conv.admin_id = admin.id
        conv.account_id = current_tenant.id
      end
    # else
    #   Conversation.find(params[:conversation_id])
    end
  
    # @message = @conversation.chat_messages.build(
    #   content: params[:content],
    #   customer_id: @conversation.customer_id,
    #   admin_id: @conversation.admin_id,
    #   admin_sender_id: admin.id,
    #   customer_sender_id: params[:customer_id],
    #   admin_username:  @conversation.admin.user_name,
    #   account_id: current_tenant.id,
    #   date_time_of_message: Time.current.strftime("%I:%M %p")
    # )

    if current_user # Admin is sending the message
      @message = @conversation.chat_messages.build(
        content: params[:content],
        admin_sender_id: admin.id, # Only set admin_sender_id
        admin_id: @conversation.admin_id,
        customer_id: @conversation.customer_id,
        account_id: current_tenant.id,
        date_time_of_message: Time.current
      )
    elsif current_customer # Customer is sending the message
      @message = @conversation.chat_messages.build(
        content: params[:content],
        customer_sender_id: current_customer.id, # Only set customer_sender_id
        account_id: current_tenant.id,
        customer_id: @conversation.customer_id,
        admin_id: @conversation.admin_id,
        date_time_of_message: Time.current
      )
    end

    if @message.save

    



      ActionCable.server.broadcast("admin_notifications", 
        ChatMessageSerializer.new(@message).as_json
        # customer_name: conversation.customer.name,
        # admin_name: find_available_admin.user_name,
        # message: conversation.chat_messages,
        # timestamp: message.created_at.strftime("%H:%M")
      )
      # broadcast_message
  #     render json: {
  #   message: @message,
  #   admin: {
  #     username: admin.user_name # Replace with the actual admin attribute
  #   }
  # }, status: :created
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  # rescue => e
  #   Rails.logger.error "Chat message error: #{e.message}"
  #   render json: { 
  #     error: 'Unable to send message', 
  #     message: 'Please try again later'
  #   }, status: :unprocessable_entity
  end







end
  private

  def broadcast_message
    ActionCable.server.broadcast(
      "conversation_#{@conversation.id}",
      ChatMessageSerializer.new(@message).as_json
    )
  end


def find_available_offline
  Admin.where(role: 'customer_support', online: false)
         .where(account_id: @account.id)  # Use @account instead
        #  .order(Arel.sql('CASE WHEN online = true THEN 0 ELSE 1 END, conversations_count ASC'))
         .first
end



  
  def find_available_admin
    # Use @account instead of current_tenant since you set it in set_tenant
    Admin.where(role: 'customer_support', online: true)
         .where(account_id: @account.id)  # Use @account instead
        #  .order(Arel.sql('CASE WHEN online = true THEN 0 ELSE 1 END, conversations_count ASC'))
         .first 
  end

  def set_tenant
    @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])

    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end
end