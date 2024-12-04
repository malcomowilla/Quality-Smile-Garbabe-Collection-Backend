class CreateBillingSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :status
      t.string :plan_name, default: 'Standard'
      t.text :features, array: true, default: []
      t.string :renewal_period, default: 'monthly'
      t.datetime :next_billing_date
      t.integer :amount_cents, default: 10000000
      t.string :currency, default: 'KES'
      t.datetime :last_payment_date
      t.string :payment_status

      t.timestamps
    end
  end
end
