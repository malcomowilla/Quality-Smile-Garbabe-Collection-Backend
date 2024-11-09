class ChatMessagesController < ApplicationController
  before_action :set_tenant 
  set_current_tenant_through_filter

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
  # 
  def index
    @conversation = if current_customer
      Conversation.find_by(customer_id: current_customer.id)
    elsif current_user&.admin?
      Conversation.find_by(id: params[:conversation_id])
    end
  
    if @conversation
      @messages = @conversation.chat_messages.order(created_at: :asc)
      render json: {
        conversation_id: @conversation.id,
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
          customer_id: current_customer.id,
          admin_id: admin.id,
          account_id: current_tenant.id  # Add this line
        )
        render json: {
          conversation_id: @conversation.id,
          admin: admin.as_json(only: [:id, :name, :online]),
          today: [],
          yesterday: []
        }
      else
        render json: { error: 'No conversation found' }, status: :not_found
      end
    end
  end



  def create
    @conversation = if current_customer
      Conversation.find_or_create_by(customer_id: current_customer.id) do |conv|
        conv.admin_id = find_available_admin.id
        conv.account_id = current_tenant.id  # 
      end
    else
      Conversation.find(params[:conversation_id])
    end

    # Time.current.strftime('%I:%M:%S %p')
    @message = @conversation.chat_messages.build(
      content: params[:content],
      customer_id: current_customer&.id,  # Changed from sender
      admin_id: current_user&.id,  
      account_id: current_tenant.id,
      date_time_of_message: Time.current.strftime("%I:%M %p")
    )


    if @message.save
      broadcast_message
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end


  private

  def broadcast_message
    ActionCable.server.broadcast(
      "conversation_#{@conversation.id}",
      ChatMessageSerializer.new(@message).as_json
    )
  end

  def find_available_admin
    Admin.where(role: 'customer_support')
         .order(Arel.sql('CASE WHEN online = true THEN 0 ELSE 1 END, conversations_count ASC'))
         .first 
  end

  def set_tenant
    @account = Account.find_or_create_by(domain: request.domain, 
    subdomain: request.subdomain)
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end
end