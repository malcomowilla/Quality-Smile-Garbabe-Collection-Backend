class CustomerPaymentSerializer < ActiveModel::Serializer
  attributes :id, :payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount, :status, :account_id, :currency
end
