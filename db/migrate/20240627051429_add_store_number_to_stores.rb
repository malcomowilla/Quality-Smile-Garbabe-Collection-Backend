class AddStoreNumberToStores < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :store_number, :string
  end
end
