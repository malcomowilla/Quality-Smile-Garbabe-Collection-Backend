class Customer < ApplicationRecord


    # validates :customer_code, presence: true, uniqueness: true

    # before_create :generate_unique_identifier
    auto_increment :sequence_number
    validates :email,  uniqueness: {case_sensitive: true}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :phone_number, uniqueness: true, presence: true
    validates :name, presence: true


    def generate_otp
        self.otp = rand(100000..999999).to_s
        save!
    end



    def verify_otp(submitted_otp)
        self.otp == submitted_otp
      end
      
    private



    # def generate_otp
    #     self.otp = rand(100000..999999).to_s
    #     save!
    # end


    # def generate_otp
    #     self.otp = SecureRandom.base64(5)
    #     save!
    # end

end



