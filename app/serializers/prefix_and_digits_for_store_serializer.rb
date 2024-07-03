class PrefixAndDigitsForStoreSerializer < ActiveModel::Serializer
  attributes :id, :prefix, :minimum_digits
end
