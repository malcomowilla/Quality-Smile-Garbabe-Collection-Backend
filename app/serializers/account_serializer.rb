class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :subdomain, :domain
  has_many :admins
end
