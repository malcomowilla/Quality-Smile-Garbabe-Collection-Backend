class ChatMessagesController < ApplicationController
  before_action :set_chat_message, only: %i[ show edit update destroy ]

  before_action :set_tenant 
  set_current_tenant_through_filter

     



  def set_tenant
    set_current_tenant(current_user.account)

end
# def set_tenant
#    random_name = "Tenant-#{SecureRandom.hex(4)}"
#   @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain, name: random_name)
 
#   set_current_tenant(@account)
 
#  end

  # def set_tenant
  #   if current_user.present? && current_user.account.present?
  #     set_current_tenant(current_user.account)
  #   else
  #     Rails.logger.debug "No tenant or current_user found"
  #     # Optionally, handle cases where no tenant is set
  #     raise ActsAsTenant::Errors::NoTenantSet
  #   end
  # end
  
  # GET /chat_messages or /chat_messages.json
  def index
#     @chat_messages = ChatMessage.all
   
    
# render json: @chat_messages
# 
#
#  @today_messages = Message.where('created_at >= ?', Time.current.beginning_of_day)
#  

# @yesterday_messages = ChatMessage.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)

# @last_week_messages = ChatMessage.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
    
# @last_month_messages = ChatMessage.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)

# render json: {
#   today: @today_messages,
#   last_week: @last_week_messages,
#   last_month: @last_month_messages,
#   yesterday: @yesterday_messages
# }
# 
@today_messages = ChatMessage.where('created_at >= ?', Time.current.beginning_of_day)
@yesterday_messages = ChatMessage.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)
@last_week_messages = ChatMessage.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
@last_month_messages = ChatMessage.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)

render json: {
  today: ActiveModelSerializers::SerializableResource.new(@today_messages, each_serializer: ChatMessageSerializer),
  yesterday: ActiveModelSerializers::SerializableResource.new(@yesterday_messages, each_serializer: ChatMessageSerializer),
  last_week: ActiveModelSerializers::SerializableResource.new(@last_week_messages, each_serializer: ChatMessageSerializer),
  last_month: ActiveModelSerializers::SerializableResource.new(@last_month_messages, each_serializer: ChatMessageSerializer)
}

  end




  # ActionCable.server.broadcast "requests_channel", 
  # {request: CustomerSerializer.new(current_customer).as_json}

# Time.current.strftime('%Y-%m-%d %I:%M:%S %p')
  def create
 
@message = ChatMessage.create(
  date_time_of_message: Time.current.strftime('%I:%M:%S %p'),
  sender_id: current_user.id,
  content: params[:content],
)


    if @message.save
      
      # ActionCable.server.broadcast "requests_channel", 
      # {request: CustomerSerializer.new(current_customer).as_json}

      

#       ActionCable.server.broadcast "message_channel_#{current_admin.id}", @message.as_json
#  ActionCable.server.broadcast "message_channel_#{params[:receiver_id]}", @message.as_json


# MessageChannel.broadcast_to(
#       current_user.user_name,
#       message: ChatMessageSerializer.new(@message)
#     )


# Rails.logger.info "Broadcasting to room: #{params[:room]}"
# ActionCable.server.broadcast "message_channel_#{params[:room]}", @message.as_json


#  ActionCable.server.broadcast "message_channel_#{params[:sender_id]}", @message.as_json
#  ActionCable.server.broadcast "message_channel_#{params[:receiver_id]}", @message.as_json

      
ActionCable.server.broadcast "message_channel", ChatMessageSerializer.new(@message).as_json 









      # # Optionally, broadcast the message using ActionCable for real-time updates
      # ActionCable.server.broadcast "message_channel",
      #  @message.as_json(include: :sender)
      render json: @message, status: :created, serializer: ChatMessageSerializer

    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /chat_messages/1 or /chat_messages/1.json
  def update
    respond_to do |format|
      if @chat_message.update(chat_message_params)
        format.html { redirect_to chat_message_url(@chat_message), notice: "Chat message was successfully updated." }
        format.json { render :show, status: :ok, location: @chat_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_messages/1 or /chat_messages/1.json
  def destroy
    @chat_message.destroy!

    respond_to do |format|
      format.html { redirect_to chat_messages_url, notice: "Chat message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_chat_message
      @chat_message = ChatMessage.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_message_params
      params.require(:chat_message).permit(:content, :date_time_of_message)
    end
end
