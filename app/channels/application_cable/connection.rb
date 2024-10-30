module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
      


    


    def connect
      self.current_user = find_verified_user
      ActsAsTenant.current_tenant = self.current_user.account
      Rails.logger.info "ActionCable#{find_verified_user}" 
    end

  
    private

    def find_verified_user
      
      token = cookies.encrypted.signed[:jwt]
      decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
      admin_id = decoded_token[0]['admin_id']


      if current_user = Admin.find_by(id: admin_id) # Or use a different method to identify user
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
