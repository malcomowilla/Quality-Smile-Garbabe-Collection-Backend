class AddRequestDateToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :request_date, :datetime
  end
end
