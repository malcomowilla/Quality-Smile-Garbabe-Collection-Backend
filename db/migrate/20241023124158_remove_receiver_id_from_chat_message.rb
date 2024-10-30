class RemoveReceiverIdFromChatMessage < ActiveRecord::Migration[7.1]
  def change
    remove_column :chat_messages, :receiver_id, :integer
  end
end
