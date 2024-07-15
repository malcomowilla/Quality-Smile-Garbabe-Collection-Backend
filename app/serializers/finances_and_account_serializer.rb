class FinancesAndAccountSerializer < ActiveModel::Serializer
  attributes :id, :category, :name, :description, :date, :reference
end
