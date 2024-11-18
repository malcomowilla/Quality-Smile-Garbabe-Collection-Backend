class SystemAdminMailer < ApplicationMailer
  require_dependency 'mailtrap_service'

  def system_admin(admin)
    @admin = admin
    template_uuid = ENV['MAIL_TRAP_SYSTEM_ADMIN_INVITE']


  if template_uuid.nil?
    Rails.logger "template uuid system admin not found"
  end


    MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
      
      to: @admin.email,
      template_uuid: template_uuid,
      template_variables: {
        "user_email" => @admin.email,
        "email_verification_link" => "http://localhost:5173/admin_verification_login_passwword?token=#{@admin.verification_token}",
        "password" => @admin.password,
      }
    )
    end
  
end