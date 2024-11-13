class PasswordResetMailer < ApplicationMailer

  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  require 'my_email_template'
  def password_reset(admin)
    @admin = admin
    account = admin.account
    
    # Get the company settings for this account
    company_settings = CompanySetting.find_by(account: account)
    @company_photo = company_settings&.logo if company_settings&.logo&.attached?
    @company_name = account.name
  
    @reset_header = EmailTemplate.first&.password_reset_header
    @admin_user_name = Admin.find_by(id: @admin.id).user_name
    @password_reset_header = MyEmailTemplate.interpolate(@reset_header, {user_name: @admin_user_name})
    @reset_body = EmailTemplate.first.password_reset_body
    @password_reset_body = MyEmailTemplate.interpolate(@reset_body, { user_email: @admin.email})
  
    mail(
      to: @admin.email,
      subject: 'Password Reset Request',
      category: 'Password Reset'
    )
  end

rescue ActiveRecord::Encryption::Errors::Decryption => e
  # Handle decryption error
  Rails.logger.error "Decryption error for admin #{admin.id}: #{e.message}"
  raise





end
