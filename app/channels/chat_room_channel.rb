class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_for chat_room
  end

  def unsubscribed
    stop_all_streams
  end
end