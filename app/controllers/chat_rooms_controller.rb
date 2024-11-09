class ChatRoomsController < ApplicationController
  before_action :set_tenant 
  set_current_tenant_through_filter

  def set_tenant
    @account = Account.find_or_create_by(domain: request.domain, subdomain: request.subdomain)
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end

  def show
    @chat_room = ChatRoom.find_or_create_by!(customer_id: current_user.id) do |room|
      room.admin_id = Admin.first.id
    end

    messages = @chat_room.chat_messages.order(created_at: :asc)
    
    render json: {
      chat_room: @chat_room,
      messages: messages
    }
  end
end