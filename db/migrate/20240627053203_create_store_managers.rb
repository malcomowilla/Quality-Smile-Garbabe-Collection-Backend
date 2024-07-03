class CreateStoreManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :store_managers do |t|
      t.string :number_of_bags_received
      t.datetime :date_reeived
      t.string :number_of_bags_delivered
      t.datetime :date_delivered

      t.timestamps
    end
  end
end
