class StoreManager < ApplicationRecord
    auto_increment :sequence_number
    acts_as_tenant(:account)
    def generate_otp
        self.otp = rand(100000..999999).to_s
        save!
    end



    def verify_otp(submitted_otp)
        self.otp == submitted_otp
      end
end
