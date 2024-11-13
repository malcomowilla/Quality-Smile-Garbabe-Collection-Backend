class ApplicationMailer < ActionMailer::Base
  # default from: "from@example.com"
  # default from: "info@aitechsent.net"
  # 
  sender_email = EmailSetting.first&.sender_email
  default from: sender_email 

  layout "mailer"
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