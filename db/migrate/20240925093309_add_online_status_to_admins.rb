class AddOnlineStatusToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :online, :boolean
  end
end
