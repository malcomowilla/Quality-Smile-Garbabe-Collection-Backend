class Customer < ApplicationRecord


    # validates :customer_code, presence: true, uniqueness: true

    # before_create :generate_unique_identifier
    auto_increment :sequence_number
    # validates :email,  uniqueness: {case_sensitive: true}, format: { with: URI::MailTo::EMAIL_REGEXP } 
    # validates :phone_number, uniqueness: true, presence: true
    # validates :name, presence: true
    acts_as_tenant(:account)


    def formatted_request_date
        request_date.strftime('%Y-%m-%d %I:%M:%S %p') if request_date.present?
    end
    
    def formatted_confirmation_date
        confirmation_date.strftime('%Y-%m-%d %I:%M:%S %p') if confirmation_date.present?
    end


    def generate_otp
        self.otp = rand(100000..999999).to_s
        # self.password = SecureRandom.base64(8)
        save!
    end


    # def formatted_request_date
    #     object.request_date.strftime('%Y-%m-%d %I:%M:%S %p') if object.request_date.present?
    #   end
    
    
    #   def formatted_confirmation_date
    #     object.confirmation_date.strftime('%Y-%m-%d %I:%M:%S %p') if object.confirmation_date.present?
    #   end

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



