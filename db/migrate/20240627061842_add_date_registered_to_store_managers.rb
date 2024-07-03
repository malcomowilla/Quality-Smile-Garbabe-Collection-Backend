class AddDateRegisteredToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :date_registered, :datetime
  end
end
