class AddDateReceivedToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :date_received, :datetime
  end
end
