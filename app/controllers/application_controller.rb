class ApplicationController < ActionController::Base
    include ActionController::Cookies
  
    skip_before_action :verify_authenticity_token
  
    helper_method :current_user, :current_admin

    rescue_from CanCan::AccessDenied do |exception|
        render json: { error: 'Access Denied' }, status: :forbidden
      end
    
  
    private

    


    def current_user
      @current_user ||= begin
        if token = cookies.signed[:jwt]
          begin
            decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
            customer_id = decoded_token[0]['customer_id']
            admin_id = decoded_token[0]['admin_id']
            service_provider_id = decoded_token[0]['service_provider_id']

            

            @current_admin = Admin.find_by(id: admin_id)
            
            @current_service_provider = ServiceProvider.find_by(id: service_provider_id)
            @current_customer = Customer.find_by(id: customer_id)
            return @current_service_provider if @current_service_provider
            return @current_customer if @current_customer
            return @current_admin if @current_admin

            # Rails.logger.info "Enqueuing SomeWorker with params: #{safe_params}"
            # CurrentUserWorker.perform_async(safe_params)
          rescue JWT::DecodeError, JWT::ExpiredSignature
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
  
    def current_ability
        if current_user.present?
          if current_user.instance_of?(Admin)
            @current_ability ||= Ability.new(current_admin)
          elsif current_user.instance_of?(Customer)
            @current_ability ||= CustomerAbility.new(current_user)
          elsif current_user.instance_of?(StoreManager)
            @current_ability ||= ServiceProviderAbility.new(current_user)
          end
        else
            raise CanCan::AccessDenied
        end
    
        
    end
  end
  