class ServiceProvider < ApplicationRecord
    auto_increment :sequence_number

    # validates :provider_code, presence: true, uniqueness: true


    # validates :email,  uniqueness: {case_sensitive: true}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    # validates :phone_number, uniqueness: true, presence: true
    

    def generate_otp
        self.otp = rand(100000..999999).to_s
        save!
    end



    def verify_otp(submitted_otp)
        self.otp == submitted_otp
      end
end
