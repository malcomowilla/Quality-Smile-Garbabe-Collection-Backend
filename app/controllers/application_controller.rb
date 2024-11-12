class ApplicationController < ActionController::Base
    include ActionController::Cookies
    set_current_tenant_through_filter
    before_action :set_tenant
    skip_before_action :verify_authenticity_token

    helper_method :current_user, :current_admin, :current_service_provider,
     :current_customer, :current_store_manager

     

     

     
     def set_tenant
      @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain)
  @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain)
     

      set_current_tenant(@account)
    
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
    



    def current_user
      @current_user ||= begin
      token = cookies.encrypted.signed[:jwt]
      
      # service_provider_token = cookies.signed[:service_provider_jwt]
      

        if  token  
          begin


            # if service_provider_token
            #   decoded_service_provider = JWT.decode(service_provider_token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
            #   service_provider_id = decoded_service_provider[0]['service_provider_id']
            #   @current_service_provider = ServiceProvider.find_by(id: service_provider_id)
            #   return @current_service_provider if @current_service_provider
            # end







            if token
              decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
              admin_id = decoded_token[0]['admin_id']

              @current_admin = Admin.find_by(id: admin_id)
              return @current_admin if @current_admin
            end

            # Rails.logger.info "Enqueuing SomeWorker with params: #{safe_params}"
            # CurrentUserWorker.perform_async(safe_params)
          rescue JWT::DecodeError, JWT::ExpiredSignature => e
            Rails.logger.error "JWT Decode Error: #{e}"
            render json: { error: 'Unauthorized' }, status: :unauthorized
          end
        end
  
        if admin_id = session[:admin_id]
          @current_admin = Admin.find_by(id: admin_id)
          return @current_admin if @current_admin
        end
  
        nil
      end
    end
  
    def current_admin
      @current_admin ||= Admin.find_by(id: session[:admin_id])
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
  