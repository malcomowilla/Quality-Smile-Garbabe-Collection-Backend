class EmailSettingsController < ApplicationController

  # before_action :set_tenant 
  # set_current_tenant_through_filter

     



  # def set_tenant
  #   @account = Account.find_by(subdomain: request.headers['X-Original-Host'])

  #   set_current_tenant(@account)
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Invalid tenant' }, status: :not_found
  # end



  # GET /email_settings or /email_settings.json
  def index
    @email_settings = EmailSetting.all
    render json: @email_settings
  end


  # POST /email_settings or /email_settings.json
  def create
    @email_setting = EmailSetting.first_or_initialize(email_setting_params)
    @email_setting.update(email_setting_params)



if @email_setting.save
  render json: @email_setting, status: :ok
else
  render json: {error: @email_setting.errors }, status: :unprocessable_entity

end
  end


  # DELETE /email_settings/1 or /email_settings/1.json
  def destroy
    @email_setting.destroy!

    respond_to do |format|
      format.html { redirect_to email_settings_url, notice: "Email setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_setting
      @email_setting = EmailSetting.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_setting_params
      params.require(:email_setting).permit(:smtp_host, :smtp_username, :sender_email, :smtp_password, :api_key, :domain)
    end
end
