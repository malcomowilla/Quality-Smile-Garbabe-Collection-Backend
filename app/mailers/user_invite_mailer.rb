class UserInviteMailer < ApplicationMailer

  require_dependency 'mailtrap_service_invite'
  

def user_invite(admin, invitation_link)
  @admin = admin
  @invite_link = invitation_link
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @admin.email,
    template_uuid: ENV['MAIL_TRAP_TEMPLATE_UUID_USER_INVITATION'],
    template_variables: {
      "user_name" => @admin.user_name,
      "next_step_link" => @invite_link
    }
  )
end
end














