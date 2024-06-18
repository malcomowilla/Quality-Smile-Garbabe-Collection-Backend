class ServiceProviderSerializer < ActiveModel::Serializer
  attributes :id, :phone_number, :name, :email, :provider_code, :status
end
