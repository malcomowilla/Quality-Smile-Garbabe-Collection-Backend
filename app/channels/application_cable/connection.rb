module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :current_customer


    def connect
      self.current_user = find_verified_user
      self.current_customer = find_verified_customer
    rescue StandardError
      reject_unauthorized_connection
    end

    private


def  find_verified_customer
  
# Try to find customer
customer_token = cookies.encrypted.signed[:customer_jwt]
if customer_token
  begin
    decoded_token = JWT.decode(customer_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
    customer_id = decoded_token[0]['customer_id']
    return Customer.find_by(id: customer_id) if customer_id
  rescue JWT::DecodeError
    # Token decode failed
  end
end
end


    def find_verified_user
      # Try to find admin first
      token = cookies.encrypted.signed[:jwt]
      if token
        begin
          decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
          admin_id = decoded_token[0]['admin_id']
          return Admin.find_by(id: admin_id) if admin_id
        rescue JWT::DecodeError
          # Token decode failed, continue to try customer auth
        end
      end

      

      # If neither admin nor customer found, reject connection
      reject_unauthorized_connection
    end
  end
end



