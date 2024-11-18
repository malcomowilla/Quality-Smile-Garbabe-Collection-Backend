class AddSystemAdminIdToCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :credentials, :system_admin_id, :integer
  end
end
