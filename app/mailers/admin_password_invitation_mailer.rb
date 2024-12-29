

class AdminPasswordInvitationMailer < ApplicationMailer
 
  require_dependency 'mailtrap_service'
  



def admins_password_invitation(admin, company_subdomain)
  
  @admin = admin




account = admin.account
    
# Get the company settings for this account
company_settings = CompanySetting.find_by(account: account)
@company_photo = company_settings&.logo if company_settings&.logo&.attached?
@company_name = CompanySetting.first&.company_name

@company_subdomain = company_subdomain
@invitation_header = EmailTemplate.first&.user_invitation_header
@admin_user_name = Admin.find_by(id: @admin.id).user_name
@user_invitation_header = MyEmailTemplate.interpolate(@invitation_header, {user_name: @admin_user_name})
@invitation_body = EmailTemplate.first&.password_reset_body
@user_invitation_body = MyEmailTemplate.interpolate(@invitation_body, { user_email: @admin.email})



mail(
  from: tenant_sender_email,
  to: @admin.email,
  subject: 'User Invite',
  category: 'Invitation',
 
)

#   template_uuid = ENV['MAIL_TRAP_ADMIN_PASSWORD']
#   if template_uuid.nil? 
#     Rails.logger.error "template uuid is nil"
# end


  # MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
  #   to: @admin.email,
  #   template_uuid: template_uuid,
  #   template_variables: {
  #     "user_name" => @admin.user_name,
  #     "admin_password" => @admin.password,
  #     "admin_email" => @admin.email,
  #     "invitation_link" => "http://localhost:517/signin"
  #     # "invitation_link" => "https://aitechs-sas-garbage-solution.onrender.com"
      
  #   }
  # )
end
end