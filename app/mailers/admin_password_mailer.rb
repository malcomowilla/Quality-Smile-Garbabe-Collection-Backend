

class AdminPasswordMailer < ApplicationMailer
 
  require_dependency 'mailtrap_service'
  

def admins_password(admin)
  
  @admin = admin
  template_uuid = ENV['MAIL_TRAP_ADMIN_PASSWORD']
  if template_uuid.nil? 
    Rails.logger.error "template uuid is nil"
end
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @admin.email,
    template_uuid: template_uuid,
    template_variables: {
      "user_name" => @admin.user_name,
      "admin_password" => @admin.password,
      "admin_email" => @admin.email,
      "invitation_link" => "http://localhost:5173/signin"
      
    }
  )
end
end