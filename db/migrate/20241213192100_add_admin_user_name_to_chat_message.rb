class AddAdminUserNameToChatMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :admin_username, :string
  end
end
