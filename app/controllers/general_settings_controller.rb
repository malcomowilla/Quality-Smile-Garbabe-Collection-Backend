class GeneralSettingsController < ApplicationController
  before_action :set_admin


  

  def create_for_store_manager
    authorize! :manage, :create_for_store_manager
@prefix_and_digits = PrefixAndDigitsForStoreManager.first_or_initialize(
     prefix:params[:prefix],
      minimum_digits:params[:minimum_digits]
)

  @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
      if @prefix_and_digits.save
        Rails.logger.info "settings updated successfully"
        render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForStoreManagerSerializer,context:{}
        

      else
        rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
        render json: {error: @prefix_and_digits.errors }
    
      end
  
      # Hello  {{name}} Welcome To QUALITY SMILES. Use Customer Code {{customer_code}} and start using our services
      # Hello {{name}} Welcome To QUALITY SMILES. Use Service Provider Code {{provider_code}} and start using our services
      # Hello, use this {{password}} as your password to invite yourself and start using our services
      # Hello use this {otp} to continue
      # Hello use this {{otp}} to continue

    # if @admin.respond_to?(:prefix_and_digits_for_store_managers)
    
    #   Rails.logger.info "prefix and digits association exists"
    #   @prefix_and_digits = @admin.prefix_and_digits_for_store_managers.first_or_initialize(
        
    #   prefix:params[:prefix],
    #   minimum_digits:params[:minimum_digits]
      
    #   )
    
    #   @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
    #   if @prefix_and_digits.save
    #     Rails.logger.info "settings updated successfully"
    #     render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForStoreManagerSerializer,context:{}
        

    #   else
    #     rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
    #     render json: {error: @prefix_and_digits.errors }
    
    #   end
  
      
    # else
    #   Rails.logger.error "prefix and digits association does not exist"
    #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

    #   # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
    # end
 
 




 end





                  
def create_admin_settings
  authorize! :manage, :create_admin_settings
if params[:login_with_otp] == true
#  

admin_settings = AdminSettings.new({ login_with_otp: params[:login_with_otp] }, 
)
      render json: admin_settings
else
  render json: { message: 'settings  updated' }

end

end



            
def get_admin_settings
  authorize! :read, :get_admin_settings
  if params[:login_with_otp] == 'true'
  #  
  
  admin_settings = AdminSettings.new( login_with_otp: params[:login_with_otp] , 
  )
        render json: admin_settings
  else
    Rails.logger.info 'settings not updated'
    render json: { message: 'settings not updated' }, status: :unprocessable_entity
  
  end
  
  end







  

 def create_for_provider
  authorize! :manage, :create_for_provider
  if params[:use_auto_generated_number_for_service_provider] == true || params[:sms_and_email_for_provider
  ] == true

  @prefix_and_digits = PrefixAndDigitsForServiceProvider.first_or_initialize(
      
      prefix:params[:prefix],
      minimum_digits:params[:minimum_digits]
  )



      @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
      if @prefix_and_digits.save
        Rails.logger.info "settings updated successfully"
        render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForServiceProviderSerializer,context:
         { use_auto_generated_number_for_service_provider:
        params[:use_auto_generated_number_for_service_provider], 
        send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider]}

      else
        rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
        render json: {error: @prefix_and_digits.errors }
    
      end

    # if @admin.respond_to?(:prefix_and_digits_for_service_providers)
    
    #   Rails.logger.info "prefix and digits association exists"
    #   @prefix_and_digits = @admin.prefix_and_digits_for_service_providers.first_or_initialize(
        
      
    #   prefix:params[:prefix],
    #   minimum_digits:params[:minimum_digits]
      
    #   )
    
    #   @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
    #   if @prefix_and_digits.save
    #     Rails.logger.info "settings updated successfully"
    #     render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForServiceProviderSerializer,context:
    #      { use_auto_generated_number_for_service_provider:
    #     params[:use_auto_generated_number_for_service_provider], 
    #     send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider]}

    #   else
    #     rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
    #     render json: {error: @prefix_and_digits.errors }
    
    #   end
  
      
    # else
    #   Rails.logger.error "prefix and digits association does not exist"
    #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

    #   # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
    # end
  else
    render json: {message: 'settings updated sucesfully'}
  end
 

 end
  

 










 def create_for_store
  authorize! :manage, :create_for_store
  @prefix_and_digits = PrefixAndDigitsForStore.first_or_initialize(
    prefix:params[:prefix],
      minimum_digits:params[:minimum_digits]
  )

  @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
      if @prefix_and_digits.save
        Rails.logger.info "settings updated successfully"
        render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForStoreSerializer,context:{}
        

      else
        rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
        render json: {error: @prefix_and_digits.errors }
    
      end
  
    # if @admin.respond_to?(:prefix_and_digits_for_stores)
    
    #   Rails.logger.info "prefix and digits association exists"
    #   @prefix_and_digits = @admin.prefix_and_digits_for_stores.first_or_initialize(
        
    #   prefix:params[:prefix],
    #   minimum_digits:params[:minimum_digits]
      
    #   )
    
    #   @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
    #   if @prefix_and_digits.save
    #     Rails.logger.info "settings updated successfully"
    #     render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForStoreSerializer,context:{}
        

    #   else
    #     rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
    #     render json: {error: @prefix_and_digits.errors }
    
    #   end
  
      
    # else
    #   Rails.logger.error "prefix and digits association does not exist"
    #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

    #   # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
    # end
 
 

 end



 def get_settings_for_store_manager
  authorize! :read, :get_settings_for_store_manager
  @prefix_and_digits = PrefixAndDigitsForStoreManager.all
  render json: @prefix_and_digits ,each_serializer: PrefixAndDigitsForStoreManagerSerializer,context:{}
  # if @admin.respond_to?(:prefix_and_digits_for_store_managers)
  #   Rails.logger.info "prefix_and_digits association exists"
  #   @prefix_and_digits =  @admin.prefix_and_digits_for_store_managers.all
  #   render json: @prefix_and_digits ,each_serializer: PrefixAndDigitsForStoreManagerSerializer,context:{}
    
  # else
  #   Rails.logger.error "prefix_and_digits association does not exist"
  #   # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
  #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

  # end
 end




 def get_settings_for_store
  authorize! :read, :get_settings_for_store
  @prefix_and_digits = PrefixAndDigitsForStore.all
  render json: @prefix_and_digits ,each_serializer: PrefixAndDigitsForStoreSerializer,context:{}
  # if @admin.respond_to?(:prefix_and_digits_for_stores)
  #   Rails.logger.info "prefix_and_digits association exists"
  #   @prefix_and_digits =  @admin.prefix_and_digits_for_stores.all
  #   render json: @prefix_and_digits ,each_serializer: PrefixAndDigitsForStoreSerializer,context:{}
    
  # else
  #   Rails.logger.error "prefix_and_digits association does not exist"
  #   # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
  #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

  # end
 end














 def get_settings_for_provider
  authorize! :read, :get_settings_for_provider
@prefix_and_digits = PrefixAndDigitsForServiceProvider.all


render json: @prefix_and_digits ,each_serializer: GeneralSettingSerializer,context:
    { use_auto_generated_number_for_service_provider:
   params[:use_auto_generated_number_for_service_provider],
  
   send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider]
  }

  # if @admin.respond_to?(:prefix_and_digits_for_service_providers)
  #   Rails.logger.info "prefix_and_digits association exists"
  #   @prefix_and_digits =  @admin.prefix_and_digits_for_service_providers.all
  #   render json: @prefix_and_digits ,each_serializer: GeneralSettingSerializer,context:
  #   { use_auto_generated_number_for_service_provider:
  #  params[:use_auto_generated_number_for_service_provider],
  
  #  send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider]
  # }
  # else
  #   Rails.logger.error "prefix_and_digits association does not exist"
  #   # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
  #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

  # end
 end







  def get_settings_for_customer
    authorize! :read, :get_settings_for_customer
    @prefix_and_digits = PrefixAndDigit.all


    render json: @prefix_and_digits, each_serializer: GeneralSettingSerializer,  context: {use_auto_generated_number:
        params[:use_auto_generated_number], send_sms_and_email: params[:send_sms_and_email]
        }


        # if @admin.respond_to?(:prefix_and_digits)
        #   Rails.logger.info "prefix_and_digits association exists"
        #   @prefix_and_digits =  @admin.prefix_and_digits.all
        #   render json: @prefix_and_digits, each_serializer: GeneralSettingSerializer,  context: {use_auto_generated_number:
        # params[:use_auto_generated_number], send_sms_and_email: params[:send_sms_and_email]
        # }
        # else
        #   Rails.logger.error "prefix_and_digits association does not exist"
        #   # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
        #   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity
    
        # end
       
  end


def create_for_customer
  authorize! :manage, :create_for_customer

if params[:use_auto_generated_number] == true || params[:send_sms_and_email] == true
  
@prefix_and_digits = PrefixAndDigit.first_or_initialize(

prefix: params[:prefix],
  minimum_digits:params[:minimum_digits]
)

# CurrentUserWorker.perform_async(@prefix_and_digits)

@prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])

  if @prefix_and_digits.save
    Rails.logger.info "settings updated successfully"
    render json: @prefix_and_digits,  status: :created, serializer: PrefixAndDigitSerializer,context: {use_auto_generated_number:
    params[:use_auto_generated_number], send_sms_and_email: params[:send_sms_and_email]
    }
  else
    rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
    render json: {error: @prefix_and_digits.errors }

  end




# if @admin.respond_to?(:prefix_and_digits)
#   Rails.logger.info "prefix and digits association exists"
#   @prefix_and_digits = @admin.prefix_and_digits.first_or_initialize(prefix: params[:prefix],
#   minimum_digits:params[:minimum_digits]
  
#   )

#   @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])

#   if @prefix_and_digits.save
#     Rails.logger.info "settings updated successfully"
#     render json: @prefix_and_digits,  status: :created, serializer: PrefixAndDigitSerializer,context: {use_auto_generated_number:
#     params[:use_auto_generated_number], send_sms_and_email: params[:send_sms_and_email]
#     }
#   else
#     rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
#     render json: {error: @prefix_and_digits.errors }

#   end
# else
#   Rails.logger.error "prefix and digits association does not exist"
#   render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

#   # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
# end
else
render json: {message: "settings updated succesfully"}
end

end
  
  

  private


  def set_admin
    @admin = Admin.find_by(id: session[:admin_id])
  Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
  Rails.logger.warn "Admin not found" unless @admin
  end


    # Use callbacks to share common setup or constraints between actions.
   

    # Only allow a list of trusted parameters through.
    def general_setting_params
      params.fetch(:general_setting, {})
    end
end
