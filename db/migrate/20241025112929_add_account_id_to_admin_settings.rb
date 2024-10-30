class AddAccountIdToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :account_id, :integer
  end
end
