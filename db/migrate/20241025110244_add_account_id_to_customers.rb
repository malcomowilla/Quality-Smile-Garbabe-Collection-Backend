class AddAccountIdToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :account_id, :integer
  end
end
