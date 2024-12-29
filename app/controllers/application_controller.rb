class ApplicationController < ActionController::Base
    include ActionController::Cookies
    set_current_tenant_through_filter
before_action :set_tenant
    skip_before_action :verify_authenticity_token
    require 'digest'

    helper_method :current_user, :current_admin, :current_service_provider,
     :current_customer, :current_store_manager, :current_sys_admin

     


    #  def set_tenant
    
    #   @account = Account.find_by(subdomain: request.headers['X-Original-Host'])
    #   ActsAsTenant.current_tenant = @account
    #   EmailSettingsConfigurator.configure(@account)
    #   @qr_png = RQRCode::QRCode.new(`https://#{request.headers['X-Original-Host']}/signin`, size: 10)
    #   @qr_png.as_png(offset: 0, color: '000000', shape_rendering: 'crispEdges', module_size: 10)
    #   send_data png_data, type: 'image/png', disposition: 'inline'  
    #   # @account = Account.find_by(subdomain: request.headers['X-Original-Host']
    #   # )
  
    #   # if @account
    #   #   ActsAsTenant.current_tenant = @account
    #   # else
    #   #   # Handle the case where the account is not found
    #   #   render json: { error: 'Tenant not found' }, status: :not_found
    #   # end

    #   Rails.logger.info "My Current Tenant: #{ActsAsTenant.current_tenant.inspect}"
    # end

    def set_tenant
      
      # @account = Account.find_by(subdomain: request.headers['X-Original-Host'])

      # if !@account
      #   render json: { error: 'Tenant not found' }, status: :not_found
      #   return
      # end
      # ActsAsTenant.current_tenant = @account
      @current_account = ActsAsTenant.current_tenant
      EmailSettingsConfigurator.configure(@current_account)
      # Define the directory for storing QR codes
      qr_codes_dir = Rails.root.join('public', 'qr_codes')
      
      # Sanitize the subdomain to ensure valid filenames
      safe_subdomain =@current_account.subdomain.gsub(/[^\w\-]/, '_')  # Replace invalid characters in the subdomain
      qr_code_path = qr_codes_dir.join("#{safe_subdomain}_qr_code.png")
    
      # Create the directory if it does not exist
      FileUtils.mkdir_p(qr_codes_dir) unless Dir.exist?(qr_codes_dir)
    
      # Check if the QR code file already exists
      if File.exist?(qr_code_path)
        Rails.logger.info "QR code for #{@current_account.subdomain} already exists."
        # No need to generate a new QR code, just return
        @qr_code_url = "/qr_codes/#{safe_subdomain}_qr_code.png"
      else
        # Generate the QR code
        qr_png = RQRCode::QRCode.new("https://#{request.headers['X-Original-Host']}/signin", size: 10)
        png_data = qr_png.as_png(offset: 0, color: '000000', shape_rendering: 'crispEdges', module_size: 10)
    
        # Save the PNG image to the file system
        File.open(qr_code_path, 'wb') do |file|
          file.write(png_data)
        end
    
        # Optionally, store the URL for the frontend
        @qr_code_url = "/qr_codes/#{safe_subdomain}_qr_code.png"
        Rails.logger.info "QR Code saved to #{qr_code_path}"
      end
    end
    
    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access Denied' }, status: :forbidden
      end

      
      def set_support_tickets_sequence_value(value)
        ActiveRecord::Base.connection.execute("SELECT setval('support_tickets_sequence_number_seq', #{value})")
      end

      def set_customers_sequence_value(value)
        ActiveRecord::Base.connection.execute("SELECT setval('customers_sequence_number_seq', #{value})")
      end

      def set_service_provider_sequence_value(value)
        ActiveRecord::Base.connection.execute("SELECT setval('service_providers_sequence_number_seq', #{value})")
      end

      def set_store_manager_sequence_value(value)
        ActiveRecord::Base.connection.execute("SELECT setval('store_managers_sequence_number_seq', #{value})")
      end

     
     
    private

def current_store_manager
  store_manager_token = cookies.encrypted.signed[:jwt_store_manager]


  if store_manager_token  
    begin




      if store_manager_token
        decoded_token_store_manager = JWT.decode(store_manager_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
        store_manager_id = decoded_token_store_manager[0]['store_manager_id']
        @current_store_manager = StoreManager.find_by(id: store_manager_id)
        return @current_store_manager if @current_store_manager
      end
     



      # Rails.logger.info "Enqueuing SomeWorker with params: #{safe_params}"
      # CurrentUserWorker.perform_async(safe_params)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error "JWT Decode Error: #{e}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end












def current_sys_admin
  sys_admin_token = cookies.encrypted.signed[:jwt_sys_admin]
  if sys_admin_token 
    begin

     



      if sys_admin_token
        decoded_sys_admin = JWT.decode(sys_admin_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
        sys_admin_id = decoded_sys_admin[0]['admin_id']
        @current_sys_admin = SystemAdmin.find_by(id: sys_admin_id)
        
        return  @current_sys_admin if  @current_sys_admin
      end



     



      # Rails.logger.info "Enqueuing SomeWorker with params: #{safe_params}"
      # CurrentUserWorker.perform_async(safe_params)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error "JWT Decode Error: #{e}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  
end



def current_customer
  customer_token = cookies.encrypted.signed[:customer_jwt]
  if  customer_token 
    begin





      if customer_token
        decoded_customer = JWT.decode(customer_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
        customer_id = decoded_customer[0]['customer_id']
        @current_customer = Customer.find_by(id: customer_id)
        return @current_customer if @current_customer
      end



     



      # Rails.logger.info "Enqueuing SomeWorker with params: #{safe_params}"
      # CurrentUserWorker.perform_async(safe_params)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error "JWT Decode Error: #{e}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
end


# def log_device(user, device_fingerprint)
#   # request.cookies.delete('device_token')
#   # request.cookie_jar.delete(:device_token)
#   browser = Browser.new(request.user_agent)
#   device_token = request.cookies['device_token'] 
#   device_fingerprint = device_fingerprint
#   # Get the device fingerprint from the request body
#   user_agent = request.headers['User-Agent']  # Get the user agent


#   unless request.cookies['device_token']
#     cookies[:device_token] = {
#       value: generate_token(12),
#       expires: 1.year.from_now,
#       secure: true,
#       httponly: true,
#     }
#   end


#   # Find or create the device based on the device_token
#   existing_device = user.devices.find_by(device_token: device_token, device_fingerprint: device_fingerprint)

#   if existing_device
#     # Update the existing device
#     existing_device.update(device_name: user_agent, last_seen_at: Time.current)
#   else
#     old_devices = user.devices.where.not(device_fingerprint: device_fingerprint)
#     # Create a new device entry
#     user.devices.create(
#       device_token: device_token,
#       # os: browser.platform,
#       device_name: user_agent,
#       last_seen_at: Time.current,
#       ip_address: request.remote_ip,
#       device_fingerprint: device_fingerprint
#     )

#     old_devices.each do |device|
#       send_device_notification(device)
#     end
  
#     # Optionally, send an email to the user
#     UserMailer.new_device_notification(user, new_device).deliver_later
#       response.status = :unauthorized
#   response.body = "Login attempt from an unrecognized device. Please confirm the login from one of your registered devices."
#   end

# end



def generate_device_fingerprint(user_agent, os)
  raw_data = "#{user_agent} #{os}"
  Digest::SHA256.hexdigest(raw_data)
end


def extract_os(user_agent)
  case user_agent
  when /Windows/i
    'Windows'
  when /Mac OS/i
    'MacOS'
  when /Linux/i
    'Linux'
  when /Android/i
    'Android'
  when /iPhone|iOS/i
    'iOS'
  else
    'Unknown'
  end
end





    def current_service_provider
      service_provider_token = cookies.encrypted.signed[:service_provider_jwt]
      if  service_provider_token
        begin


          if service_provider_token
            decoded_service_provider = JWT.decode(service_provider_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
            service_provider_id = decoded_service_provider[0]['service_provider_id']
            @current_service_provider = ServiceProvider.find_by(id: service_provider_id)
            return @current_service_provider if @current_service_provider
          end
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.error "JWT Decode Error: #{e}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    end
    end
    



    
  
    def current_admin
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  



    def current_user
      @current_user ||= begin
        token = cookies.encrypted.signed[:jwt]
        if token  
          begin
            decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
            admin_id = decoded_token[0]['admin_id']
            @current_admin = Admin.find_by(id: admin_id)
            return @current_admin if @current_admin
          rescue JWT::DecodeError, JWT::ExpiredSignature => e
            Rails.logger.error "JWT Decode Error: #{e}"
            render json: { error: 'Unauthorized' }, status: :unauthorized
          end
        end
        nil
      end
    end
    # current_service_provider,
    #  :current_customer, :current_store_manager


# def current_customer_ability
# if current_customer.present?
#   @current_ability ||= CustomerAbility.new(current_customer,current_user )
# else
#   raise CanCan::AccessDenied
# end
# end

def current_sys_admin_ability
  if current_sys_admin.present?
    @current_ability ||= Ability.new(current_service_provider)
  else
    raise CanCan::AccessDenied
  end
end


def current_service_provider_ability
if current_service_provider.present?
  @current_ability ||= ServiceProviderAbility.new(current_service_provider)
else
  raise CanCan::AccessDenied
end
end



def current_store_manager_ability
if current_store_manager.present?
  @current_ability ||= StoreManagerAbility.new(current_store_manager)
else
  raise CanCan::AccessDenied
end
end

def current_user_ability
  if current_user.present?
    @current_ability ||= Ability.new(current_user)
  else
    raise CanCan::AccessDenied
  end
end



def generate_token()
  generate_secure_password(length = 12)

end

  
def generate_secure_password(length = 12)
  raise ArgumentError, 'Length must be at least 8' if length < 8

  # Define the character sets
  lowercase = ('a'..'z').to_a
  uppercase = ('A'..'Z').to_a
  digits = ('0'..'9').to_a
  symbols = %w[! @ # $ % ^ & * ( ) - _ = + { } [ ] | : ; " ' < > , . ? /]

  # Combine all character sets
  all_characters = lowercase + uppercase + digits + symbols

  # Ensure the password contains at least one character from each set
  password = []
  password << lowercase.sample
  password << uppercase.sample
  password << digits.sample
  password << symbols.sample

  # Fill the rest of the password length with random characters from all sets
  (length - 4).times { password << all_characters.sample }

  # Shuffle the password to ensure randomness
  password.shuffle!

  # Join the array into a string
  password.join
end


    # def current_ability

    #   if current_user.present?
    #     @current_ability ||= Ability.new(current_user)
     
    #   else
    #     raise CanCan::AccessDenied
    #   end
    #     # if current_user.present?
    #     #   @current_ability ||= Ability.new(current_user)
    #     #   # if current_user.instance_of?(Admin)
    #     #   #   @current_ability ||= Ability.new(current_admin)
    #     #   # elsif current_user.instance_of?(Customer)
    #     #   #   @current_ability ||= CustomerAbility.new(current_user)
    #     #   # elsif current_user.instance_of?(ServiceProvider)
    #     #   #   @current_ability ||= ServiceProviderAbility.new(current_service_provider)
    #     #   # elsif current_user.instance_of?(StoreManager)
    #     #   #   @current_ability ||= StoreManagerAbility.new(current_user)
    #     #   # end
    #     # elsif  current_customer.present?
    #     #   current_ability ||= CustomerAbility.new(current_customer)
    #     # elsif current_service_provider.present?
    #     #   @current_ability ||= ServiceProviderAbility.new(current_service_provider)

    #     # elsif current_store_manager.present?
    #     #   @current_ability ||= StoreManagerAbility.new(current_store_manager)
        
    #     # else
    #     #     raise CanCan::AccessDenied
    #     # end
    
        
    # end
  end
  