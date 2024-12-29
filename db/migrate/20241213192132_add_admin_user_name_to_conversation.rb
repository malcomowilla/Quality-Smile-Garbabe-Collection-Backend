class AddAdminUserNameToConversation < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :admin_username, :string
  end
end
