class AddChatManagementToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_manage_chats, :boolean
    add_column :admins, :can_read_chats, :boolean
  end
end
