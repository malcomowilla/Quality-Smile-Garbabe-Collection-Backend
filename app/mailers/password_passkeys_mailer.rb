
class PasswordPasskeysMailer < ApplicationMailer




  require_dependency 'mailtrap_service'
    
  # secret_key_base: 8f757ece8ae271b68e5782d52b49409d618aca8d0133392830f7c17107c555>


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