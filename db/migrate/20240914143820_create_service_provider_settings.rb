class CreateServiceProviderSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :service_provider_settings do |t|
      t.string :prefix
      t.string :minimum_digits
      t.boolean :use_auto_generated_number_for_service_provider
      t.boolean :send_sms_and_email_for_provider
      t.boolean :enable_2fa_for_service_provider
      t.boolean :send_email_for_provider

      t.timestamps
    end
  end
end
