class LocationSerializer < ActiveModel::Serializer
  attributes :id, :location_name, :sub_location, :location_code, :category, :account_id
  belongs_to :account

end
