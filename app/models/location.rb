class Location < ApplicationRecord

    validates :location_name, presence: true, uniqueness: true

    acts_as_tenant(:account)



end
