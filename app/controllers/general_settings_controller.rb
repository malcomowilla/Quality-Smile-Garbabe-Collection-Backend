class GeneralSettingsController < ApplicationController
  before_action :set_admin

 def create_for_provider
  if params[:use_auto_generated_number_for_service_provider] == true
    if @admin.respond_to?(:prefix_and_digits_for_service_providers)
    
      Rails.logger.info "prefix and digits association exists"
      @prefix_and_digits = @admin.prefix_and_digits_for_service_providers.first_or_initialize(
        
      use_auto_generated_number_for_service_provider: params[:use_auto_generated_number_for_service_provider],
      prefix:params[:prefix],
      minimum_digits:params[:minimum_digits]
      
      )
    
      @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])
      if @prefix_and_digits.save
        Rails.logger.info "settings updated successfully"
        render json: @prefix_and_digits, status: :created, serializer: PrefixAndDigitsForServiceProviderSerializer,context:
         { use_auto_generated_number_for_service_provider:
        params[:use_auto_generated_number_for_service_provider], }
      else
        rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
        render json: {error: @prefix_and_digits.errors }
    
      end
  
      
    else
      Rails.logger.error "prefix and digits association does not exist"
      render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

      # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
    end
  else
    render json: {message: 'settings updated sucesfully'}
  end
 

 end
  

 


 def get_settings_for_provider

  if @admin.respond_to?(:prefix_and_digits_for_service_providers)
    Rails.logger.info "prefix_and_digits association exists"
    @prefix_and_digits =  @admin.prefix_and_digits_for_service_providers.all
    render json: @prefix_and_digits ,each_serializer: GeneralSettingSerializer,context:
    { use_auto_generated_number_for_service_provider:
   params[:use_auto_generated_number_for_service_provider], }
  else
    Rails.logger.error "prefix_and_digits association does not exist"
    # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
    render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

  end
 end


  def get_settings_for_customer

        if @admin.respond_to?(:prefix_and_digits)
          Rails.logger.info "prefix_and_digits association exists"
          @prefix_and_digits =  @admin.prefix_and_digits.all
          render json: @prefix_and_digits, each_serializer: GeneralSettingSerializer,  context: {use_auto_generated_number:
        params[:use_auto_generated_number], 
        }
        else
          Rails.logger.error "prefix_and_digits association does not exist"
          # render json: { error: "admin does not have a 'prefix_and_digits' relationship" }, status: :unprocessable_entity
          render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity
    
        end
       
  end


def create_for_customer


if params[:use_auto_generated_number] == true
  
if @admin.respond_to?(:prefix_and_digits)
  Rails.logger.info "prefix and digits association exists"
  @prefix_and_digits = @admin.prefix_and_digits.first_or_initialize(prefix: params[:prefix],
  minimum_digits:params[:minimum_digits]
  
  )

  @prefix_and_digits.update(prefix:params[:prefix], minimum_digits: params[:minimum_digits])

  if @prefix_and_digits.save
    Rails.logger.info "settings updated successfully"
    render json: @prefix_and_digits,  status: :created, serializer: PrefixAndDigitSerializer,context: {use_auto_generated_number:
    params[:use_auto_generated_number], 
    }
  else
    rails.logger.warn "failed to update settings #{@prefix_and_digits.errors.full_messages.join(", ")}"
    render json: {error: @prefix_and_digits.errors }

  end
else
  Rails.logger.error "prefix and digits association does not exist"
  render json: { error: "your not allowed to change this settings" }, status: :unprocessable_entity

  # render json: {error: "admin does not have prefix and digits relationship"}, status: :unprocessable_entity
end
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
    def set_general_setting
      @general_setting = GeneralSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def general_setting_params
      params.fetch(:general_setting, {})
    end
end
