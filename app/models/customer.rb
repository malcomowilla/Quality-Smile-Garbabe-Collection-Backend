class Customer < ApplicationRecord

    before_create :generate_unique_identifier

    private

    def generate_unique_identifier
        self.unique_identifier = SecureRandom.uuid
        
    end
end
