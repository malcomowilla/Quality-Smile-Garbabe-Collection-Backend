class LocationSerializer < ActiveModel::Serializer
  attributes :id, :location_name, :sub_location, :location_code, :category
end
