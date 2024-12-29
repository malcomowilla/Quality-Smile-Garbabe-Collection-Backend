class CreateCustomerWalletPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_wallet_payments do |t|

      t.timestamps
    end
  end
end
