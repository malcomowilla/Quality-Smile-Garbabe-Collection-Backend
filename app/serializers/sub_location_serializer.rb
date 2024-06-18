class SubLocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :created_by, :category
end
