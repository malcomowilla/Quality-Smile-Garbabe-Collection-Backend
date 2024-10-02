
class PasswordPasskeysMailer < ApplicationMailer




  require_dependency 'mailtrap_service'
    


  def password_passkeys(admin)
      @admin = admin
      template_uuid = ENV['MAIL_TRAP_PASSKEYS_PASSWORD']
  
      if template_uuid.nil? 
        Rails.logger.error "template uuid is nil"
    end
    
      MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
        to: @admin.email,
        template_uuid: template_uuid,
        template_variables: {
          "user_name" => @admin.user_name,
          "user_password" => @admin.password,
          "user_email" => @admin.email
          
        }
      )
    end






end