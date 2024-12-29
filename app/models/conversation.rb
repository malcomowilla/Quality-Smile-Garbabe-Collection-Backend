class Conversation < ApplicationRecord


  # belongs_to :sender, class_name: 'Customer'
  # belongs_to :receiver, class_name: 'Admin'
  has_many :chat_messages, dependent: :destroy

  belongs_to :customer
  belongs_to :admin
  # has_many :chat_messages, dependent: :destroy
  # Ensure that each user-pair has only one conversation between them

  validates :customer_id, presence: true
  validates :admin_id, presence: true

  def self.between(customer_id, admin_id)
    find_or_create_by(customer_id: customer_id, admin_id: admin_id)
  end
  # def self.between(sender_id, receiver_id)
  #   where(sender_id: sender_id, receiver_id: receiver_id)
  #     .or(where(sender_id: receiver_id, receiver_id: sender_id))
  #     .first_or_create(sender_id: sender_id, receiver_id: receiver_id)
  # end
  

end
