class Location < ApplicationRecord

    validates :location_name, presence: true, uniqueness: true

end
