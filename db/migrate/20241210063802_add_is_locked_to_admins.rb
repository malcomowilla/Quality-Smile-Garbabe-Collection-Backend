class AddIsLockedToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :locked_account, :boolean, default: false
  end
end



