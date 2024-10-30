class AddAccountIdToCustomerSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :customer_settings, :account_id, :integer
  end
end
