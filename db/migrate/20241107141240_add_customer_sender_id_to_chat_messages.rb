class AddCustomerSenderIdToChatMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :customer_sender_id, :integer
  end
end
