class CompanySettingsController < ApplicationController
  # before_action :set_company_setting, only: %i[ show edit update destroy ]

  # before_action :set_tenant 
  # set_current_tenant_through_filter

  # def set_tenant
  #   @account = Account.find_by(subdomain: request.headers['X-Original-Host'])
  
  #   set_current_tenant(@account)
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Invalid tenant' }, status: :not_found
  # end

  # GET /company_settings or /company_settings.json
  def index
    # @company_settings = CompanySetting.first
     @account = ActsAsTenant.current_tenant
     @company_settings = @account.company_setting
    # render json: @company_settings
    render json: {
      company_name: @company_settings&.company_name,
      contact_info: @company_settings&.contact_info,
      email_info: @company_settings&.email_info,
      agent_email: @company_settings&.agent_email,
      customer_support_email: @company_settings&.customer_support_email,
      customer_support_phone_number: @company_settings&.customer_support_phone_number,
      logo_url: @company_settings&.logo&.attached? ? url_for(@company_settings.logo) : nil
      }


      # ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do


      # end
  end

  # 
  
  # POST /company_settings or /company_settings.json
  def create

    
  @company_setting = CompanySetting.first_or_initialize(company_setting_params)
  @company_setting.update!(company_setting_params)
  if @company_setting.save
    # render json: @company_setting
    render json: {
company_name: @company_setting.company_name,
customer_support_email: @company_setting.customer_support_email,
customer_support_phone_number: @company_setting.customer_support_phone_number,
agent_email: @company_setting.agent_email,
contact_info: @company_setting.contact_info,
email_info: @company_setting.email_info,
logo_url: @company_setting.logo.attached? ? url_for(@company_setting.logo) : nil
}
  else
    render json: { errors: @company_setting.errors }, status: :unprocessable_entity

  end
  end



  private
   

    # Only allow a list of trusted parameters through.
    def company_setting_params
      params.permit(:company_name, :contact_info,
       :email_info, :logo, :customer_support_phone_number, :agent_email, :customer_support_email)
    end
end
