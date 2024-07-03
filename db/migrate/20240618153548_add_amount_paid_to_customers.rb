class AddAmountPaidToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :amount_paid, :string
  end
end
