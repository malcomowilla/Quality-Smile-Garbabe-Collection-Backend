
class AdminOtpMailer < ApplicationMailer

  require_dependency 'mailtrap_service'
  

def admins_otp(admin)
  
  @admin = admin
  template_uuid = ENV['MAIl_TRAP_ADMIN_OTP']
  if template_uuid.nil? 
    Rails.logger.error "template uuid is nil"
end
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @admin.email,
    template_uuid: template_uuid,
    template_variables: {
      "user_name" => @admin.user_name,
      "admin_otp" => @admin.otp,
      
    }
  )
end
end














