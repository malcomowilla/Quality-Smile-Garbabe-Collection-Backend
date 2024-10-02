class ChatMessage < ApplicationRecord
  # belongs_to :admin
  # belongs_to :chat_room
  # 
  #
  #
    belongs_to :sender, class_name: 'Admin'
  belongs_to :receiver, class_name: 'Admin'

  validates :content, presence: true
end
