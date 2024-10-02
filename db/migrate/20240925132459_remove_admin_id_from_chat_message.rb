class RemoveAdminIdFromChatMessage < ActiveRecord::Migration[7.1]
  def change
    remove_column :chat_messages, :admin_id, :string
  end
end
