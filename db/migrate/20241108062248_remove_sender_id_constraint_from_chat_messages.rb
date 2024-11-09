class RemoveSenderIdConstraintFromChatMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :chat_messages, :sender_id if column_exists?(:chat_messages, :sender_id)
    remove_column :chat_messages, :sender_type if column_exists?(:chat_messages, :sender_type)
  end
end
