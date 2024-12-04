json.extract! customer_payment, :id, :payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount, :status, :account_id, :currency, :created_at, :updated_at
json.url customer_payment_url(customer_payment, format: :json)
