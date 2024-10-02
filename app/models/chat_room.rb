class ChatRoom < ApplicationRecord


  has_many :messages, dependent: :destroy
  has_many :admins, through: :messages




# @chat_room = ChatRoom.find(params[:id])
# @messages = @chat_room.messages.includes(:user)

def self.user_conversations(admin)
  ChatRoom.joins(:chat_messages).where(chat_messages: { admin_id: admin.id }).distinct
end






end
















