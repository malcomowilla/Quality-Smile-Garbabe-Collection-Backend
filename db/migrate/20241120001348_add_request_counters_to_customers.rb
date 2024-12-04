class AddRequestCountersToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :total_requests, :integer, default: 0
    add_column :customers, :total_confirmations, :integer, default: 0
  end
end
