# class ApplicationMailer < ActionMailer::Base
#   # default from: "from@example.com"
#   # default from: "info@aitechsent.net"
#   # 
#   sender_email = EmailSetting.first.sender_email
#   default from: sender_email 

#   # layout "mailer"
# end


class ApplicationMailer < ActionMailer::Base
  before_action :set_sender_email
  before_action :set_tenant
  skip_before_action :verify_authenticity_token

  layout "mailer"

  helper_method :current_user, :current_admin, :current_service_provider,
                :current_customer, :current_store_manager

  private

  def set_sender_email
    # Get sender email safely with a fallback
    email_setting = EmailSetting.first
    sender_email = email_setting&.sender_email 
    default from: sender_email
  end

  def set_tenant
    @account = Account.find_or_create_by(
      domain: request.domain, 
      subdomain: request.subdomain
    )
    set_current_tenant(@account)
  end
end


