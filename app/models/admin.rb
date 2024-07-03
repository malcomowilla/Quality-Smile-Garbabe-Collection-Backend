class Admin < ApplicationRecord
    has_secure_password
    has_secure_token :reset_password_token
    has_many :prefix_and_digits, dependent: :destroy
    has_many :prefix_and_digits_for_service_providers,  dependent: :destroy
    has_many :prefix_and_digits_for_stores, dependent: :destroy
has_many :prefix_and_digits_for_store_managers, dependent: :destroy


def generate_password_reset_token
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
end

def reset_password(password)
    update(password: password, reset_password_token: nil)
end

def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
end

def generate_otp
    self.otp = rand(100000..999999).to_s
    save!
end



def verify_otp(submitted_otp)
    self.otp == submitted_otp
  end


    
    validates :password_confirmation, confirmation: { case_sensitive: true}

    validate :validate_complex_password
    
    validates :email,  uniqueness: {case_sensitive: true}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    # validate :validate_email_format
    validates :user_name, presence: true, length: {minimum: 6, maximum: 30}, uniqueness: true
    def validate_email_format
        unless email.end_with?('@gmail.com') || email.end_with?('co.ke')
            errors.add(:email, 'must be a valid email adress ending with gmail.com')
        end
    end
    
    
    # validates :password, presence: true, uniqueness: true
    # validates :password, uniqueness: true, presence: true
    # validate :validate_complex_password
    
       
    
    
    
    def validate_complex_password
        if password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$/) 
            errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit,
             and needs to be minimum 12 characters."
    
    
          end
    end
end


private

def generate_token
    # SecureRandom.hex(10)
    SecureRandom.base64(16)
end
