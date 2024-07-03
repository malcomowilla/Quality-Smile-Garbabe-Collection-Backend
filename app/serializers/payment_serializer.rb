class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount
end
