class CompanySettingsController < ApplicationController
  # before_action :set_company_setting, only: %i[ show edit update destroy ]

  before_action :set_tenant 
  set_current_tenant_through_filter

  def set_tenant
    @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain)
  
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end

  # GET /company_settings or /company_settings.json
  def index
    # @company_settings = CompanySetting.first
    @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain)
    @company_settings = @account.company_setting
    # render json: @company_settings
    render json: {
      company_name: @company_settings.company_name,
      contact_info: @company_settings.contact_info,
      email_info: @company_settings.email_info,
      logo_url: @company_settings.logo.attached? ? url_for(@company_settings.logo) : nil
      }
  end

  # 
  
  # POST /company_settings or /company_settings.json
  def create

    
  @company_setting = CompanySetting.first_or_initialize(company_setting_params)
  @company_setting.update(company_setting_params)
  if @company_setting.save
    # render json: @company_setting
    render json: {
company_name: @company_setting.company_name,
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
       :email_info, :logo)
    end
end
