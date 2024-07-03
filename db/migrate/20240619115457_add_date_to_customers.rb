class AddDateToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :date, :date
  end
end
