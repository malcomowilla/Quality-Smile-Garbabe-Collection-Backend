class ResetPasswordMailer < ApplicationMailer

    require_dependency 'mailtrap_service_reset_password'
    

def password_forgotten(admin)
    @admin = admin
    MailtrapService.new('f17620673c51e537ef268dea49025da8').send_template_email(
      to: @admin.email,
      template_uuid: ENV['MAIL_TRAP_TEMPLATE_UUID2'],
      template_variables: {
        "user_email" => @admin.email,
        "reset_password_url" => "http://localhost:5173/reset_password?token=#{@admin.reset_password_token}"
        
      }
    )
  end
end
