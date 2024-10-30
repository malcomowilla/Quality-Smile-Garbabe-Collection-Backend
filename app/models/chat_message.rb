class ChatMessage < ApplicationRecord
  # belongs_to :admin
  # belongs_to :chat_room
  
  
  acts_as_tenant(:account)
  
    belongs_to :sender, class_name: 'Admin',foreign_key: "sender_id"
  # belongs_to :receiver, class_name: 'Admin',foreign_key: "receiver_id"

  validates :content, presence: true
end
