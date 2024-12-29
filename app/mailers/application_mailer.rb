class ApplicationMailer < ActionMailer::Base

  layout "mailer"

  private

  # Helper method to fetch the dynamic sender email based on the current tenant
  def tenant_sender_email
    if ActsAsTenant.current_tenant
      ActsAsTenant.current_tenant.email_setting&.sender_email || 'info@aitechsent.net'
    else
      'info@aitechsent.net'
    end
  end
end


# class ApplicationMailer < ActionMailer::Base
# layout "mailer"

# # Set default sender email at the class level
# default from: -> { EmailSetting.first&.sender_email }

# before_action :set_tenant

# helper_method :current_user, :current_admin, :current_service_provider,
#               :current_customer, :current_store_manager

# private

# def set_tenant
#   @account = Account.find_or_create_by(
#     domain: request.domain, 
#     subdomain: request.subdomain
#   )
#   set_current_tenant(@account)
# end

# end