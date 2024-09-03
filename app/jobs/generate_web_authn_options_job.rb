class GenerateWebAuthnOptionsJob < ApplicationJob
  queue_as :default
  def perform(admin)
        # invitation_link = "http://localhost:5173/web_authn_registration?&email=#{admin.email}"
        # UserInviteMailer.user_invite(admin, invitation_link).deliver_now
        # 
        # Rails.logger.info "Starting GenerateWebAuthnOptionsJob for admin: #{admin.email}"
    invitation_link = "http://localhost:5173/web_authn_registration?&email=#{admin.email}"
    UserInviteMailer.user_invite(admin, invitation_link).deliver_now
    Rails.logger.info "Completed GenerateWebAuthnOptionsJob for admin: #{admin.email}"
  rescue => e
    Rails.logger.error "Error in GenerateWebAuthnOptionsJob: #{e.message}"
    raise e
  
  end
end
