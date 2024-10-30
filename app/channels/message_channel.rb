class MessageChannel < ApplicationCable::Channel
  def subscribed
    ActsAsTenant.with_tenant(current_user.account) do

    stream_from "message_channel"
    # stream_for params[:receiver_id]
    # stream_from "current_user_#{current_user.id}"
        # stream_from "current_user_#{params[:receiver_id]}"
        # stream_from "message_channel_#{params[:room]}" 
    # stream_for Admin.find(params[:receiver_id])
    # stream_for current_user.user_name
  end
end

  def unsubscribed
    
  end

  # def receive(data)
  #   ActionCable.server.broadcast "message_channel_#{params[:room]}", data
  # end

end








