class AddAccountIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :account_id, :integer
  end
end
