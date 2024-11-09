class RemovePolymorphicColumnsFromChatMessages < ActiveRecord::Migration[7.1]
  def change
    remove_index :chat_messages, name: "index_chat_messages_on_receiver"
    remove_index :chat_messages, name: "index_chat_messages_on_sender_type_and_sender_id"
    
    remove_column :chat_messages, :receiver_type
    remove_column :chat_messages, :sender_type
  end
end
