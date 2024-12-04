class SystemAdmin < ApplicationRecord
has_secure_password
# has_many :credentials
has_many :system_admin_credentials
def generate_email_verification_token(admin)
  # SecureRandom.urlsafe_base64
  # self.reset_password_token = generate_token

  # self.reset_password_sent_at = Time.now.utc
  admin.update(verification_token: generate_token)
  # admin.update_column(:reset_password_sent_at, Time.now)

end





def password_token_valid?
  (reset_password_sent_at + 4.hours) > Time.now.utc
end










# def verify_otp(submitted_otp)
#   self.otp == submitted_otp
  
# end



#   validates :password, presence: true,unless: :skip_password_validation?

  # validates :password_confirmation, confirmation: { presence: true},unless: :skip_password_validation?

  # validate :validate_complex_password, unless: :skip_password_validation
  
  # validates :email,  format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  # validate :validate_email_format
  # validates :user_name, uniqueness: true

  private
  
  

  # validates :password, presence: true, uniqueness: true
  # validates :password, uniqueness: true, presence: true
  # validate :validate_complex_password
  
     
  
  
  








def generate_token
  # SecureRandom.hex(10)
  SecureRandom.base64(16)
end

end
