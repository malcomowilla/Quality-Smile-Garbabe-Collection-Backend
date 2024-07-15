module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = Admin.find_by(id: decode_token)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def decode_token
      if token = cookies.signed[:jwt]
        begin
          decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
          return decoded_token[0]['admin_id']
        rescue JWT::DecodeError, JWT::ExpiredSignature
          nil
        end
      end
      nil
    end
  end
end
