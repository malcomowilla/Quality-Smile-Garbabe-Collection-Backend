class StoreSerializer < ActiveModel::Serializer
  attributes :id, :amount_of_bags, :status, :from_store, :location
end
