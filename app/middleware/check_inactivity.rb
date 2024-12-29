# class CheckInactivity
#   def initialize(app)
#     @app = app
#   end


#   def call(env)
#     request = ActionDispatch::Request.new(env)
    
#     # List of paths to bypass
#     bypass_paths = [
#       '/webauthn/register', '/webauthn/create', '/webauthn/verify', '/webauthn/authenticate', 
#       '/current_user', '/logout-admin', '/invite_register_with_webauth', '/logout_store_manager',
#       '/confirm_deivered_bags_from_store', '/signup-admin', '/login-admin',
#       'send_chat_message'
#     ]


#     # Skip middleware for bypass paths
#     if bypass_paths.any? { |path| request.path.start_with?(path) }
#       return @app.call(env)
#     end



#     @account = Account.find_or_create_by(domain: request.domain, subdomain: request.subdomain)
#     ActsAsTenant.current_tenant = @account


#     service_provider_token = request.cookie_jar.encrypted.signed[:service_provider_jwt]
#     token = request.cookie_jar.encrypted.signed[:jwt]
#     store_manager_token = request.cookie_jar.encrypted.signed[:jwt_store_manager]
#     customer_token = request.cookie_jar.encrypted.signed[:customer_jwt]
#     if token || store_manager_token || customer_token || service_provider_token
#       Rails.logger.info "JWT from cookie: #{request.cookies['jwt']}"
#       Rails.logger.info "JWT from cookie store manager: #{request.cookies['jwt']}"
#       Rails.logger.info "JWT from cookie : #{request.cookies['jwt']}"
#       Rails.logger.info "JWT from cookie: #{request.cookies['jwt']}"
#       begin
       
        

#         # if service_provider_token == !nil
#         #   decoded_token_service_provider = JWT.decode(service_provider_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
#         #   service_provider_id = decoded_token_service_provider[0]['service_provider_id']

#         #   if service_provider_id
#         #     service_provider = ServiceProvider.find_by(id: service_provider_id)
#         #     if service_provider.nil?
#         #       Rails.logger.info "service provider not found with ID: #{service_provider_id}"
#         #       return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#         #     end
        
#         #   end
#         # end


# # if customer_token 
# #   decoded_token_customer = JWT.decode(customer_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
# #   customer_id = decoded_token_customer[0]['customer_id']

# #   if customer_id
# #     customer = Customer.find_by(id: customer_id)
# #     if customer.nil?
# #       Rails.logger.info "Customer not found with ID: #{customer_id}"
# #       return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
# #     end

# #   end
# # end


# #  if store_manager_token
# #           decoded_token_store_manager = JWT.decode(store_manager_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
# #           store_manager_id = decoded_token_store_manager[0]['store_manager_id']
# #            Rails.logger.info "Decoded token store manager: #{decoded_token_store_manager.inspect}"
# #           store_manager = StoreManager.find_by(id: store_manager_id)
# #           if store_manager.nil?
# #             Rails.logger.info "Store Manager not found with ID: #{store_manager_id}"
# #             return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
# #           end
        
# #         end







       


#         if token 
#           decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')

#           admin_id = decoded_token[0]['admin_id']


#             if admin_id
#           admin = Admin.find_by(id: admin_id)
#           if admin.nil?
#             Rails.logger.info "Admin not found with ID: #{admin_id}"
#             return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#           end
# # ActsAsTenant.current_tenant = admin.account
# # 








#           admin = Admin.find_by(id: admin_id)
#           admin_settings = AdminSettings.first
# if_check_is_inactive = admin_settings&.check_is_inactive
# if_check_is_inactive_minutes = admin_settings&.check_is_inactiveminutes
# if_check_is_inactive_hrs = admin_settings&.check_is_inactivehrs

#           # if admin_settings.check_is_inactive == nil
#           #   admin_settings_nil = AdminSettings.first_or_initialize(check_is_inactive: false)
#           # end
        





#           if if_check_is_inactive == true 
#             admin.update_column(:enable_inactivity_check,true)

#           elsif if_check_is_inactive == false
#             admin.update_column(:enable_inactivity_check, false)
#           elsif admin_settings == nil

#             admin.update_column(:enable_inactivity_check, false)
#             admin.update_column(:enable_inactivity_check_hours, false)
#             admin.update_column(:enable_inactivity_check_minutes, false)

#           elsif if_check_is_inactive_hrs == true

#               admin.update_column(:enable_inactivity_check_hours, true)

#           elsif if_check_is_inactive_minutes == true
#             admin.update_column(:enable_inactivity_check_minutes, true)
#           end
#           # admin.enable_inactivity_check = AdminSettings.first_or_initialize(check_is_inactive: false) if admin_settings.nil?


#           # admin.enable_inactivity_check = admin_settings_nil.check_is_inactive
#           # admin.enable_inactivity_check = admin_settings.check_is_inactive
#           if admin.enable_inactivity_check
#           if admin.inactive
#             # admin.update_column(:inactive, true)
#             # request.cookie_jar.delete('jwt')
#             return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Account inactive, please log in again' }.to_json]]
#           end
#         end


#         if admin.enable_inactivity_check_minutes
#           if admin.inactive
#             # admin.update_column(:inactive, true)
#             # request.cookie_jar.delete('jwt')
#             return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Account inactive, please log in again' }.to_json]]
#           end
#         end



#         if admin.enable_inactivity_check_hours
#           if admin.inactive
#             # admin.update_column(:inactive, true)
#             # request.cookie_jar.delete('jwt')
#             return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Account inactive, please log in again' }.to_json]]
#           end
#         end
#         end

#       end


#         # Rails.logger.info "Received JWT: #{token}"
#         # Rails.logger.info "Received JWT  store manager: #{store_manager_token}"
#         # decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
       
        
#         # Rails.logger.info "Decoded token: #{decoded_token.inspect}"
       
#         # admin_id = decoded_token[0]['admin_id']
#         # customer_id = decoded_token[0]['customer_id']

#         # if admin_id
#         #   admin = Admin.find_by(id: admin_id)
#         #   if admin.nil?
#         #     Rails.logger.info "Admin not found with ID: #{admin_id}"
#         #     return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#         #   end

#         #   if admin.inactive
#         #     admin.update!(inactive: true)
#         #     request.cookie_jar.delete('jwt')
#         #     return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Account inactive, please log in again' }.to_json]]
#         #   end
#         # elsif store_manager_token
#         #   decoded_token_store_manager = JWT.decode(store_manager_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
#         #   store_manager_id = decoded_token_store_manager[0]['store_manager_id']
#         #    Rails.logger.info "Decoded token store manager: #{decoded_token_store_manager.inspect}"
#         #   store_manager = StoreManager.find_by(id: store_manager_id)
#         #   if store_manager.nil?
#         #     Rails.logger.info "Store Manager not found with ID: #{store_manager_id}"
#         #     return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#         #   end
#         #   # No inactivity check for store managers in this example
#         # elsif customer_id
#         #   customer = Customer.find_by(id: customer_id)
#         #   if customer.nil?
#         #     Rails.logger.info "Customer not found with ID: #{customer_id}"
#         #     return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#         #   end
#         # end

#       rescue JWT::DecodeError => e
#         Rails.logger.error "JWT decode error: #{e.message}"
#         request.cookie_jar.delete('jwt')
#         return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
#       end
#     end

#     @app.call(env)
#   end
# end




class CheckInactivity
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    # Rails.logger.info "current tenant in middleware#{ActsAsTenant.current_tenant}"

    Rails.logger.info "Skipping inactivity check for non-admin path: #{request.path.split('/').reject(&:empty?)[0]}"

    # Skip WebSocket connections
    if request.path.start_with?('/cable', '/get_company_settings')
      Rails.logger.info "Skipping inactivity check for websocket path: #{request.path}"
      return @app.call(env)
    end
    # Skip non-admin paths
    # /api/get_calendar_settings
    # /api/get_settings_for_admin
    # /api/get_provider_settings
    # /api/get_locations
    # /api/get_store_settings
    # /api/get_sub_locations
    # /api/stores
    # /api/get_ticket_settings
    # /api/customers
    # /api/chat_messages
    # /api/get_store_managers
    # /api/get_service_providers
    # /api/get_admins
    # /api/all_sms
    # /api/get_tickets
    # /api/get_company_settings
    # /api/chat_messages


    admin_sensitive_paths = [
      'get_admins',
      'get_calendar_settings',
      'get_settings_for_admin',
      'get_provider_settings',
      'get_locations',
      'get_store_settings',
      'get_sub_locations',
      'stores',
      'get_ticket_settings',
      'customers',
      'get_store_managers',
      'get_service_providers',
      'all_sms',
      'get_tickets',
    ]


    path_segments = request.path.split('/').reject(&:empty?)
    target_path = path_segments[0] # Skip 'api' prefix



    unless admin_sensitive_paths.include?(target_path)
      Rails.logger.info "Request object: #{request.inspect}"

      Rails.logger.info "Skipping inactivity check for non-admin path: #{target_path}"
      return @app.call(env)
    end
    Rails.logger.info "Request object: #{request.inspect}"

    Rails.logger.info "Checking inactivity for admin path: #{request.path}"

    # @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])
    # ActsAsTenant.current_tenant = @account

    token = request.cookie_jar.encrypted.signed[:jwt]
    
    if token
      begin
        decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
        admin_id = decoded_token[0]['admin_id']

        if admin_id
          admin = Admin.find_by(id: admin_id)
          if admin
            admin_settings = AdminSettings.first
            
            if admin_settings
              # admin.update_columns(
              #   enable_inactivity_check: admin_settings.check_is_inactive == true,
              #   enable_inactivity_check_hours: admin_settings.check_is_inactivehrs == true,
              #   enable_inactivity_check_minutes: admin_settings.check_is_inactiveminutes == true
              # )


               
                  
                  if admin_settings.check_is_inactive == true && admin.inactive == true
                Rails.logger.info "Inactivity check triggered for admin: #{admin.id}"
                # Clear the JWT cookie
                # request.cookie_jar.delete(:jwt)
                
                # Return unauthorized with a clear message
                response = Rack::Response.new
                response.status = 401
                response.set_header('Content-Type', 'application/json')
                response.set_header('X-Session-Expired', 'true')
                response.write({ 
                  error: 'Account inactive, please log in again',
                  code: 'SESSION_EXPIRED'
                }.to_json)
                
                return response.finish
              end
            end
          end
        end
      rescue JWT::DecodeError => e
        Rails.logger.error "JWT decode error: #{e.message}"
        request.cookie_jar.delete(:jwt)
        return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid or expired token' }.to_json]]
      end
    end

    @app.call(env)
  end
end