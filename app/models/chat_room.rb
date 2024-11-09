class ChatRoom < ApplicationRecord


  # has_many :messages, dependent: :destroy
  # has_many :admins, through: :messages

  # belongs_to :customer
  # belongs_to :admin
  # has_many :chat_messages, dependent: :destroy

# @chat_room = ChatRoom.find(params[:id])
# @messages = @chat_room.messages.includes(:user)
# validates :customer_id, uniqueness: { scope: :admin_id }

# def self.user_conversations(admin)
#   ChatRoom.joins(:chat_messages).where(chat_messages: { admin_id: admin.id }).distinct
# end






end
















