class RemoveAccountIdFromSystemAdminCredentials < ActiveRecord::Migration[7.1]
  def change
    remove_column :system_admin_credentials, :account_id, :integer
  end
end
