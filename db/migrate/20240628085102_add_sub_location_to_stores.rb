class AddSubLocationToStores < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :sub_location, :string
  end
end
