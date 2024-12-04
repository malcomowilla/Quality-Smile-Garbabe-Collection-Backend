class AddAccountIdToSystemAdminCredential < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admin_credentials, :account_id, :integer
  end
end
