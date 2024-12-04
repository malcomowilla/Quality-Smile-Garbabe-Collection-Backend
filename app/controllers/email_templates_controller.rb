class EmailTemplatesController < ApplicationController

  # before_action :set_tenant 
  # set_current_tenant_through_filter

     


  # def set_tenant
  #   @account = Account.find_by(subdomain: request.headers['X-Original-Host'])
  
  #   set_current_tenant(@account)
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Invalid tenant' }, status: :not_found
  # end

  
  # GET /email_templates or /email_templates.json
  def index
    @email_templates = EmailTemplate.all
    render json:  @email_templates
  end




  # POST /email_templates or /email_templates.json
  def create

    @email_template = EmailTemplate.first_or_initialize(email_template_params)
    @email_template.update(email_template_params)



if @email_template.save
  render json: @email_template, status: :ok
else
  render json: {error: @email_template.errors }, status: :unprocessable_entity

end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_template_params
      params.require(:email_template).permit(:customer_confirmation_code_header, :customer_confirmation_code_body, 
      :customer_confirmation_code_footer, :service_provider_confirmation_code_header, :service_provider_confirmation_code_body, 
      :service_provider_confirmation_code_footer, :user_invitation_header, :user_invitation_body, :user_invitation_footer, :customer_otp_confirmation_header, :customer_otp_confirmation_body,
       :customer_otp_confirmation_footer, 
      :service_provider_otp_confirmation_header, :service_provider_otp_confirmation_body, :service_provider_otp_confirmation_footer, :admin_otp_confirmation_header, :admin_otp_confirmation_body,
       :admin_otp_confirmation_footer, :store_manager_otp_confirmation_header, :store_manager_otp_confirmation_body, :store_manager_otp_confirmation_footer, :store_manager_number_header, :store_manager_number_body,
        :store_manager_number_footer,
        :payment_reminder_header,
       :payment_reminder_body, :payment_reminder_footer,
       :password_reset_body, :password_reset_footer, :password_reset_header)
    end
end
