class SmsTemplatesController < ApplicationController
  before_action :set_sms_template, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /sms_templates or /sms_templates.json
  def index
    @sms_templates = SmsTemplate.all
    render json: @sms_templates
  end


  # POST /sms_templates or /sms_templates.json
  def create
    @sms_template = SmsTemplate.first_or_initialize(sms_template_params)
    @sms_template.update(sms_template_params)

    if @sms_template.save
         render json: @sms_template, status: :created 
      else
       render json: @sms_template.errors, status: :unprocessable_entity 
      end
    
  end

  # PATCH/PUT /sms_templates/1 or /sms_templates/1.json
  def update
    respond_to do |format|
      if @sms_template.update(sms_template_params)
        format.html { redirect_to sms_template_url(@sms_template), notice: "Sms template was successfully updated." }
        format.json { render :show, status: :ok, location: @sms_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sms_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_templates/1 or /sms_templates/1.json
  def destroy
    @sms_template.destroy!

    respond_to do |format|
      format.html { redirect_to sms_templates_url, notice: "Sms template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_template
      @sms_template = SmsTemplate.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sms_template_params
      params.require(:sms_template).permit(:customer_confirmation_code_template, :service_provider_confirmation_code_template, :user_invitation_template, :customer_otp_confirmation_template, :service_provider_otp_confirmation_template, :admin_otp_confirmation_template, :payment_reminder_template)
    end
end
