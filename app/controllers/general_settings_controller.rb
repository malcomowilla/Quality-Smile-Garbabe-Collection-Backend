class GeneralSettingsController < ApplicationController
  # before_action :set_admi
  before_action :update_last_activity
 


  def update_last_activity
    if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
    end
    
  end

  def create_for_tickets
    authorize! :manage, :create_for_tickets
    prefix_and_digits = PrefixAndDigitsForTicketNumber.first_or_initialize(
      prefix:params[:prefix],
      minimum_digits:params[:minimum_digits]
    )


    prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
    if prefix_and_digits.save
      Rails.logger.info "settings updated successfully"
      render json: prefix_and_digits, status: :created, serializer: PrefixAndDigitsForTicketNumberSerializer,context:{}
      

    else
      Rails.logger.warn "failed to update settings #{prefix_and_digits.errors.full_messages.join(", ")}"
      render json: {errors: prefix_and_digits.errors }
  
    end
  end
  

  def get_settings_for_tickets
    authorize! :read, :get_settings_for_tickets
    prefix_and_digits = PrefixAndDigitsForTicketNumber.all
  render json: prefix_and_digits ,each_serializer: PrefixAndDigitsForTicketNumberSerializer
  
  end


  def create_for_store_manager


    authorize! :manage, :create_for_store_manager
# @prefix_and_digits = PrefixAndDigitsForStoreManager.first_or_initialize(
#      prefix:params[:prefix],
#       minimum_digits:params[:minimum_digits],
      
# )



store_manager_settings = StoreManagerSetting.first_or_initialize(
  prefix: params[:prefix],
  minimum_digits: params[:minimum_digits],
  send_manager_number_via_sms: params[:send_manager_number_via_sms],
  enable_2fa_for_store_manager: params[:enable_2fa_for_store_manager],
  send_manager_number_via_email: params[:send_manager_number_via_email]
  


)


store_manager_settings.update(
  prefix: params[:prefix],
  minimum_digits: params[:minimum_digits],
  send_manager_number_via_sms: params[:send_manager_number_via_sms],
  enable_2fa_for_store_manager: params[:enable_2fa_for_store_manager],
  send_manager_number_via_email: params[:send_manager_number_via_email]
  
)





if store_manager_settings.save
  render json: store_manager_settings,status: :ok
else
  render json: {error: @prefix_and_digits.errors }
end








  # @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits],
  
  # send_manager_number_via_sms:  params[:send_manager_number_via_sms], 
  #  send_manager_number_via_email: params[:send_manager_number_via_email], 
  #  enable_2fa_for_store_manager: params[:enable_2fa_for_store_manager]
  # )
  #     if @prefix_and_digits.save
  #       Rails.logger.info "settings updated successfully"
  #       render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForStoreManagerSerializer,context:{
  #         send_manager_number_via_sms:  params[:send_manager_number_via_sms], 
  #  send_manager_number_via_email: params[:send_manager_number_via_email], 
  #  enable_2fa_for_store_manager: params[:enable_2fa_for_store_manager]
  #       }
        

  #     else
  #       rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
  #       render json: {error: @prefix_and_digits.errors }
    
  #     end
  #     









  
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
# if params[:login_with_otp] == true || params[:login_with_otp] == 'true'
#    params[:login_with_web_auth] == true || params[:login_with_otp_email] == true || params[:login_with_web_auth] == 'true'  ||
#     params[:login_with_otp_email] == 'true'

Rails.logger.info "enale 2fa=>#{params[:enale_2fa_for_admin]}"
admin_settings = AdminSettings.first_or_initialize(
check_inactive_days: params[:check_inactive_days],
check_inactive_hrs: params[:check_inactive_hrs],
check_inactive_minutes: params[:check_inactive_minutes],
login_with_otp: to_boolean(params[:login_with_otp]), login_with_web_auth:
to_boolean(params[:login_with_web_auth]), login_with_otp_email: to_boolean(params[:login_with_otp_email]),

check_is_inactive: 
to_boolean(params[:check_is_inactive]),
send_password_via_email: to_boolean(params[:send_password_via_email]), 
send_password_via_sms: to_boolean(params[:send_password_via_sms] ),
enable_2fa_for_admin: to_boolean(params[:enable_2fa_for_admin]),
enable_2fa_for_admin_passkeys: to_boolean(params[:enable_2fa_for_admin_passkeys])


)


admin_settings.update(
  enable_2fa_for_admin_passkeys: 
  to_boolean(params[:enable_2fa_for_admin_passkeys]),
  check_inactive_days: params[:check_inactive_days],
  check_inactive_minutes: params[:check_inactive_minutes],
check_inactive_hrs: params[:check_inactive_hrs],
enable_2fa_for_admin: to_boolean(params[:enable_2fa_for_admin]),
login_with_otp: to_boolean(params[:login_with_otp]), login_with_web_auth:
to_boolean(params[:login_with_web_auth]), login_with_otp_email: to_boolean(params[:login_with_otp_email]),
check_is_inactive: 
to_boolean(params[:check_is_inactive]),
send_password_via_email: to_boolean(params[:send_password_via_email]), 
send_password_via_sms: to_boolean(params[:send_password_via_sms] )
)
if admin_settings.save
  render json: admin_settings
else
  render json: { errors: admin_settings.errors.full_messages }, status: :unprocessable_entity
end
 



end


def allow_get_admin_settings
  
  admin_settings = AdminSettings.all
  render json: admin_settings
end






            
def get_admin_settings
  authorize! :read, :get_admin_settings
  
  admin_settings = AdminSettings.all
  # admin_settings = AdminSettings.new( login_with_otp: to_boolean(params[:login_with_otp]) , 
  # login_with_web_auth: to_boolean(params[:login_with_web_auth]), login_with_otp_email: 
  # to_boolean(params[:login_with_otp_email]), send_password_via_sms: to_boolean(params[:send_password_via_sms] ),
  # send_password_via_email: to_boolean(params[:send_password_via_email])
  # )
        render json: admin_settings
       

  
  
  end







  

 def create_for_provider

  authorize! :manage, :create_for_provider
  if params[:use_auto_generated_number_for_service_provider] == true 

  # @prefix_and_digits = PrefixAndDigitsForServiceProvider.first_or_initialize(
      
  #     prefix:params[:prefix],
  #     minimum_digits:params[:minimum_digits]
  # )

  service_provider_settings = ServiceProviderSetting.first_or_initialize(
    prefix: params[:prefix],
    minimum_digits: params[:minimum_digits],
    use_auto_generated_number_for_service_provider: to_boolean(params[:use_auto_generated_number_for_service_provider]),
    send_sms_and_email_for_provider: to_boolean(params[:send_sms_and_email_for_provider]),
    enable_2fa_for_service_provider: to_boolean(params[:enable_2fa_for_service_provider]),
    send_email_for_provider: to_boolean(params[:send_email_for_provider]),
  )



service_provider_settings.update(
  prefix: params[:prefix],
  minimum_digits: params[:minimum_digits],
  use_auto_generated_number_for_service_provider: to_boolean(params[:use_auto_generated_number_for_service_provider]),
  send_sms_and_email_for_provider: to_boolean(params[:send_sms_and_email_for_provider]),
  enable_2fa_for_service_provider: to_boolean(params[:enable_2fa_for_service_provider]),
  send_email_for_provider: to_boolean(params[:send_email_for_provider])

)



if service_provider_settings.save
  render json: service_provider_settings, status: :ok
else

  render json: {error: @prefix_and_digits.errors }
end











      # @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
      # if @prefix_and_digits.save
      #   Rails.logger.info "settings updated successfully"
      #   render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForServiceProviderSerializer,context:
      #    { use_auto_generated_number_for_service_provider:
      #   params[:use_auto_generated_number_for_service_provider], 
      #   send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider],
      #   enable_2fa_for_service_provider: params[:enable_2fa_for_service_provider],
      #   send_email_for_provider: params[:send_email_for_provider]
      
      # }

      # else
      #   rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
      #   render json: {error: @prefix_and_digits.errors }
    
      # end

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




 def allow_get_settings_for_store_manager
  store_managers_settings = StoreManagerSetting.all
  render json: store_managers_settings
 end

 def get_settings_for_store_manager
  authorize! :read, :get_settings_for_store_manager
  # 
  #


  store_managers_settings = StoreManagerSetting.all
  render json: store_managers_settings











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








def allow_get_settings_for_provider
  authorize! :read, :get_settings_for_provider
  # @prefix_and_digits = PrefixAndDigitsForServiceProvider.all
  service_provider_settings = ServiceProviderSetting.all
  render json: service_provider_settings,status: :ok
  
end




 def get_settings_for_provider
  authorize! :read, :get_settings_for_provider
# @prefix_and_digits = PrefixAndDigitsForServiceProvider.all
service_provider_settings = ServiceProviderSetting.all
render json: service_provider_settings,status: :ok

# render json: @prefix_and_digits ,each_serializer: GeneralSettingSerializer,context:
#     { use_auto_generated_number_for_service_provider:
#    params[:use_auto_generated_number_for_service_provider],
#    send_email_for_provider: params[:send_email_for_provider],
#    enable_2fa_for_service_provider: params[:enable_2fa_for_service_provider],
  
#    send_sms_and_email_for_provider: params[:send_sms_and_email_for_provider]
#   }

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


def allow_get_customer_settings
  customer_settings = CustomerSetting.all
  render json: customer_settings
end




  def get_settings_for_customer
    authorize! :read, :get_settings_for_customer
    # @prefix_and_digits = PrefixAndDigit.all


    # render json: @prefix_and_digits, each_serializer: GeneralSettingSerializer,  context: {use_auto_generated_number:
    #     params[:use_auto_generated_number], send_sms_and_email: params[:send_sms_and_email], send_email: params[:send_email],
    #     enable_2fa:params[:enable_2fa]
    #     }
    #     
    customer_settings = CustomerSetting.all
    render json: customer_settings


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


  # MyCalendarSetting


  def get_calendar_settings
    authorize! :read, :get_calendar_settings
    calendar_settings = MyCalendarSetting.all
    render json: calendar_settings
  end





  def create_calendar_settings
    authorize! :manage, :create_calendar_settings

      calendar_settings = MyCalendarSetting.first_or_initialize(
        start_in_minutes: params[:start_in_minutes],
        start_in_hours: params[:start_in_hours]
      )

      calendar_settings.update(
        start_in_minutes: params[:start_in_minutes],
        start_in_hours: params[:start_in_hours]
      )


if calendar_settings.save
  render json: calendar_settings, status: :ok
else
  render json: {error: calendar_settings.errors }, status: :unprocessable_entity

end

  end




def create_for_customer
  authorize! :manage, :create_for_customer
  if params[:use_auto_generated_number] == true 
  
  customer_settings = CustomerSetting.first_or_initialize(
    prefix: params[:prefix],
  minimum_digits:params[:minimum_digits],
  use_auto_generated_number: to_boolean(params[:use_auto_generated_number]),
  send_sms_and_email: to_boolean(params[:send_sms_and_email]),
  enable_2fa: to_boolean(params[:enable_2fa]),
  send_email: to_boolean(params[:send_email]),
  )




  customer_settings.update(
    prefix: params[:prefix],
    minimum_digits:params[:minimum_digits],
    use_auto_generated_number: to_boolean(params[:use_auto_generated_number]),
    send_sms_and_email: to_boolean(params[:send_sms_and_email]),
    enable_2fa: to_boolean(params[:enable_2fa]),
    send_email: to_boolean(params[:send_email]),
  )


if customer_settings.save
  render json: customer_settings, status: :ok
else
  render json: {error: customer_settings.errors }, status: :unprocessable_entity

end







# # if params[:use_auto_generated_number] == true || params[:send_sms_and_email] == true
  
# @prefix_and_digits = PrefixAndDigit.first_or_initialize(

# prefix: params[:prefix],
#   minimum_digits:params[:minimum_digits]
# )

# # CurrentUserWorker.perform_async(@prefix_and_digits)

# @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])

#   if @prefix_and_digits.save
#     Rails.logger.info "settings updated successfully"
#     render json: @prefix_and_digits,  status: :created, serializer: PrefixAndDigitSerializer,context: {use_auto_generated_number:
#     params[:use_auto_generated_number], enable_2fa: params[:enable_2fa], 
#         send_email: params[:send_email], send_sms_and_email: params[:send_sms_and_email]
#     }
#   else
#     Rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
#     render json: {error: @prefix_and_digits.errors }

#   end




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



  def to_boolean(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
  
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
