class AddDateRegisteredToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :date_registered, :date
  end
end
