class AddPrefixAndDigitsForStoreManagerToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :prefix, :string
    add_column :store_managers, :minimum_digits, :string
  end
end
