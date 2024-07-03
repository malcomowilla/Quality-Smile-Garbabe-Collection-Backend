class AddBagConfirmedToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :bag_confirmed, :boolean, default: false
  end
end
