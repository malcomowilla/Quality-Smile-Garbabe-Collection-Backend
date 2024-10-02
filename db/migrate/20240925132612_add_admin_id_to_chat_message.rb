class AddAdminIdToChatMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :admin_id, :integer
  end
end
