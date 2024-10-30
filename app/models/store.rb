class Store < ApplicationRecord

    validates :store_number,  uniqueness: true
    auto_increment :sequence_number
    acts_as_tenant(:account)
end
