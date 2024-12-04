class CreateSubscriptionPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :subscription_id, :bigint
    add_column :payments, :payment_method, :string
    add_column :payments, :amount_cents, :integer
    add_column :payments, :currency, :string, default: 'KES'
    add_column :payments, :status, :string
    add_column :payments, :transaction_reference, :string
    add_column :payments, :mpesa_phone_number, :string
    add_column :payments, :mpesa_receipt_number, :string
    add_column :payments, :payment_details, :jsonb

    add_index :payments, :subscription_id
    add_index :payments, :transaction_reference, unique: true
    add_index :payments, :mpesa_receipt_number, unique: true
    
    add_foreign_key :payments, :subscriptions
  end
end
