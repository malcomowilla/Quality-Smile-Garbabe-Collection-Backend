class CreateEmailTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :email_templates do |t|
      t.string :customer_confirmation_code_header
      t.string :customer_confirmation_code_body
      t.string :customer_confirmation_code_footer
      t.string :service_provider_confirmation_code_header
      t.string :service_provider_confirmation_code_body
      t.string :service_provider_confirmation_code_footer
      t.string :user_invitation_header
      t.string :user_invitation_body
      t.string :user_invitation_footer
      t.string :customer_otp_confirmation_header
      t.string :customer_otp_confirmation_body
      t.string :customer_otp_confirmation_footer
      t.string :service_provider_otp_confirmation_header
      t.string :service_provider_otp_confirmation_body
      t.string :service_provider_otp_confirmation_footer
      t.string :admin_otp_confirmation_header
      t.string :admin_otp_confirmation_body
      t.string :admin_otp_confirmation_footer
      t.string :store_manager_otp_confirmation_header
      t.string :store_manager_otp_confirmation_body
      t.string :store_manager_otp_confirmation_footer
      t.string :store_manager_number_header
      t.string :store_manager_number_body
      t.string :store_manager_number_footer
      t.string :payment_reminder_header
      t.string :payment_reminder_body
      t.string :payment_reminder_footer

      t.timestamps
    end
  end
end
