class CreateStoreManagerSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :store_manager_settings do |t|
      t.string :prefix
      t.string :minimum_digits
      t.boolean :send_manager_number_via_sms
      t.boolean :send_manager_number_via_email
      t.boolean :enable_2fa_for_store_manager

      t.timestamps
    end
  end
end
