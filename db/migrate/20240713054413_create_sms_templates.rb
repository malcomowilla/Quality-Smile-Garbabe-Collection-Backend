class CreateSmsTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :sms_templates do |t|
      t.string :customer_confirmation_code_template
      t.string :service_provider_confirmation_code_template
      t.string :user_invitation_template
      t.string :customer_otp_confirmation_template
      t.string :service_provider_otp_confirmation_template
      t.string :admin_otp_confirmation_template
      t.string :payment_reminder_template

      t.timestamps
    end
  end
end
