

class NotifyLoginMailer < ApplicationMailer

  def notify_login(admin, device_verification_token, device_verification_url, ip_address, user_agent,
    company_name
     )
    @admin = admin
    @device_verification_token = device_verification_token
    @device_verification_url = device_verification_url
@user_agent = user_agent
@ip_address = ip_address
@last_seen_at = @admin.devices.order(last_seen_at: :desc).first.last_seen_at if @admin.devices.exists?
@company_name =  company_name if company_name


mail(
  from: tenant_sender_email,
  to: @admin.email,
  subject: 'New Device Login Notification',
  category: 'New Device Login Notification',
 
)
  end
end