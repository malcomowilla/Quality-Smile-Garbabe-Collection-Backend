class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :payment_code
      t.string :phone_number
      t.string :name
      t.string :amount_paid
      t.string :total
      t.string :remaining_amount

      t.timestamps
    end
  end
end
