class RemovePrefixAndDigitsFromStoreManagers < ActiveRecord::Migration[7.1]
  def change
    remove_column :store_managers, :prefix, :string
    remove_column :store_managers, :minimum_digits, :string
  end
end
