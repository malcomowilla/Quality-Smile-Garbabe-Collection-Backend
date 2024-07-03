class Store < ApplicationRecord

    validates :store_number,  uniqueness: true
    auto_increment :sequence_number

end
