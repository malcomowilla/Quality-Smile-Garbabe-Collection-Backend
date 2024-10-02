class SmsTemplateSerializer < ActiveModel::Serializer
  attributes :id, :customer_confirmation_code_template, :service_provider_confirmation_code_template, 
  :user_invitation_template, :customer_otp_confirmation_template, :service_provider_otp_confirmation_template, 
  :admin_otp_confirmation_template, :payment_reminder_template,
:store_manager_otp_confirmation_template, 
:store_manager_manager_number_confirmation_template




end
