
class StoreManagerOtpMailer < ApplicationMailer

  require_dependency 'mailtrap_service'
  

def store_manager_otp(store_manager)
  @store_manager = store_manager

  template_uuid =  ENV['MAIL_TRAP_TEMPLATE_UUID_STORE_MANAGER_OTP']


  if template_uuid.nil?
    Rails.logger "template uuid store manager not found"
  end
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @store_manager.email,
    template_uuid: template_uuid,
    template_variables: {
      "user_name" => @store_manager.name,
      "store_manager_otp" => @store_manager.otp
    }
  )
end
end














