class AddAdminIdToPrefixAndDigitsForStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :prefix_and_digits_for_store_managers, :admin_id, :integer
  end
end
