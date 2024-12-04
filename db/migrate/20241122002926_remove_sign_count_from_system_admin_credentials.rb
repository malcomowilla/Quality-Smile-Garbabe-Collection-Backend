class RemoveSignCountFromSystemAdminCredentials < ActiveRecord::Migration[7.1]
  def change
    remove_column :system_admin_credentials, :sign_count, :string
  end
end
