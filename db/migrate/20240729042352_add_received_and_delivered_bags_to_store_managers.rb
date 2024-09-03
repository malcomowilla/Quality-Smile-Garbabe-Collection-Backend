class AddReceivedAndDeliveredBagsToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :delivered_bags, :boolean, default: false
    add_column :store_managers, :received_bags, :boolean, default: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
