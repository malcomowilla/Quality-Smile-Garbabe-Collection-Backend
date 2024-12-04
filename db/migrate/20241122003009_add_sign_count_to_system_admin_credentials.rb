class AddSignCountToSystemAdminCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admin_credentials, :sign_count, :integer
  end
end
