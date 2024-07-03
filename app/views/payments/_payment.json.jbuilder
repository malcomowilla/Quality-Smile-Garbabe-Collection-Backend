json.extract! payment, :id, :payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount, :created_at, :updated_at
json.url payment_url(payment, format: :json)
