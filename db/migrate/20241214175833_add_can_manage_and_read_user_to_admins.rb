class AddCanManageAndReadUserToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_read_user, :boolean
    add_column :admins, :can_manage_user, :boolean
  end
end
