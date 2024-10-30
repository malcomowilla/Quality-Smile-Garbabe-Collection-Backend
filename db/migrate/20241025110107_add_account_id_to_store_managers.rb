class AddAccountIdToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :account_id, :integer
  end
end
