class AddAccountIdToStoreManagerSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :store_manager_settings, :account_id, :integer
  end
end
