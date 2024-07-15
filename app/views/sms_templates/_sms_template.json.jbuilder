json.extract! sms_template, :id, :customer_confirmation_code_template, :service_provider_confirmation_code_template, :user_invitation_template, :customer_otp_confirmation_template, :service_provider_otp_confirmation_template, :admin_otp_confirmation_template, :payment_reminder_template, :created_at, :updated_at
json.url sms_template_url(sms_template, format: :json)
