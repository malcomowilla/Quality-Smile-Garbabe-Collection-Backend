class CreateCustomerSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_settings do |t|
      t.boolean :send_sms_and_email
      t.boolean :send_email
      t.string :prefix
      t.string :minimum_digits
      t.boolean :use_auto_generated_number
      t.boolean :enable_2fa

      t.timestamps
    end
  end
end
