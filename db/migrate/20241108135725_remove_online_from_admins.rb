class RemoveOnlineFromAdmins < ActiveRecord::Migration[7.1]
  def change
    remove_column :admins, :online, :boolean
  end
end
