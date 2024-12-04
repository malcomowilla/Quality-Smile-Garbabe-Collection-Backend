class CreateCustomerPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_payments do |t|
      t.string :payment_code
      t.string :phone_number
      t.string :name
      t.string :amount_paid
      t.string :total
      t.string :remaining_amount
      t.string :status
      t.integer :account_id
      t.string :currency

      t.timestamps
    end
  end
end
