class AddReceiverAndCurrentAdminIdToChatMessages < ActiveRecord::Migration[7.1]
  def change


      add_column :chat_messages, :sender_id, :integer
    add_column :chat_messages, :receiver_id, :integer
  end
end
