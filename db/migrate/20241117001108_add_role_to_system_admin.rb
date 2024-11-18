class AddRoleToSystemAdmin < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admins, :role, :string
  end
end
