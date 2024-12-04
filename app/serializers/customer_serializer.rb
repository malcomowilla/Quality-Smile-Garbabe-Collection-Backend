class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_number, :location, :unique_identifier, :amount_paid, :customer_code, :date, 
  :date_registered, :bag_confirmed, :confirm_request, :formatted_confirmation_date, :formatted_request_date,
  :total_requests, :total_confirmations


  def formatted_request_date
    object.request_date.strftime('%Y-%m-%d %I:%M:%S %p') if object.request_date.present?
  end


  def formatted_confirmation_date
    object.confirmation_date.strftime('%Y-%m-%d %I:%M:%S %p') if object.confirmation_date.present?
  end

end