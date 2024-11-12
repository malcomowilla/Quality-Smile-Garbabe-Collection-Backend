class SmsSettingsController < ApplicationController
  before_action :set_tenant

  set_current_tenant_through_filter




  def set_tenant
    @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])
  
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end



  # GET /sms_settings or /sms_settings.json
  def index
    @sms_settings = SmsSetting.all
    render json: @sms_settings
  end



  # POST /sms_settings or /sms_settings.json
  def create
    @sms_setting = SmsSetting.first_or_initialize(sms_setting_params)
    @sms_setting.update(sms_setting_params)
      if @sms_setting.save
        render json: @sms_setting, status: :created
      else
        render json: @sms_setting.errors, status: :unprocessable_entity  
      end
    
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_setting
      @sms_setting = SmsSetting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sms_setting_params
      params.require(:sms_setting).permit(:api_key, :api_secret)
    end
end
