class ChatMessage < ApplicationRecord
  # belongs_to :admin
  # belongs_to :chat_room
  
  acts_as_tenant(:account)
  belongs_to :customer, optional: true
  belongs_to :admin, optional: true
  belongs_to :conversation

  validates :content, presence: true

  validate :must_have_sender

  def must_have_sender
    unless customer_id.present? || admin_id.present?
      errors.add(:base, "Message must have either a customer or admin sender")
    end
  end
  #   belongs_to :sender, class_name: 'Admin',foreign_key: "sender_id"
  #   belongs_to :sender, class_name: 'Customer',foreign_key: "sender_id"

  #   #  belongs_to :customer_sender, class_name: 'Customer',foreign_key: "customer_sender_id"
  # belongs_to :receiver, class_name: 'Admin',foreign_key: "receiver_id"

  private

  
end


