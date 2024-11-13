class SmsController < ApplicationController

before_action :update_last_activity
before_action :set_tenant 








before_action :set_tenant 
set_current_tenant_through_filter

   



def set_tenant
    @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])

  set_current_tenant(@account)
rescue ActiveRecord::RecordNotFound
  render json: { error: 'Invalid tenant' }, status: :not_found
end






# def set_tenant
#   if current_user.present? && current_user.account.present?
#     set_current_tenant(current_user.account)
#   else
#     Rails.logger.debug "No tenant or current_user found"
#     # Optionally, handle cases where no tenant is set
#     raise ActsAsTenant::Errors::NoTenantSet
#   end
# end

  def update_last_activity
    if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))


    end
  end
  
  # GET /sms or /sms.json
  def get_all_sms
    authorize! :read, :get_all_sms
    @sms = Sm.all
    render json: @sms
  end

  def get_sms_balance
    authorize! :read, :get_sms_balance
    get_balance
   
  end



  def status_message
    status_secret = ENV['SMS_LEOPARD_SECRET_KEY']
    received_secret = params[:status_secret]
    if received_secret == status_secret
      Rails.logger.info "SMS Status Callback Received: #{params.inspect}"
      # Extract the message content from params
      message_sent = params[:message]
      Rails.logger.info "Message sent: #{message_sent}"
      
      # Process the received data as needed
      render json: { message: "SMS status received successfully", sent_message: message_sent }, status: :ok
    else
      Rails.logger.error "Invalid status secret in callback: #{params.inspect}"
      render json: { error: "Invalid status secret" }, status: :unauthorized
    end
  end


  # POST /sms or /sms.json
  def create_sms
    authorize :manage, :create_sms
    @sm = Sm.new(sm_params)
@sm.update(date: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
      if @sm.save
         render json: @sm, status: :created
      else
         render json: @sm.errors, status: :unprocessable_entity 
    end
  end








  # PATCH/PUT /sms/1 or /sms/1.json
  def update
    respond_to do |format|
      if @sm.update(sm_params)
        format.html { redirect_to sm_url(@sm), notice: "Sm was successfully updated." }
        format.json { render :show, status: :ok, location: @sm }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms/1 or /sms/1.json
  def destroy
    set_sm
    @sm.destroy

       head :no_content 
    
  end

  private




  def send_sms(message, user)
    api_key = ENV['SMS_LEOPARD_API_KEY']
    api_secret = ENV['SMS_LEOPARD_API_SECRET']
    sms_template = message
   
    sender_id = "SMS_TEST" 

    uri = URI("https://api.smsleopard.com/v1/sms/send")
    params = {
      username: api_key,
      password: api_secret,
      message: sms_template,
      destination: user,
      source: sender_id
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      sms_data = JSON.parse(response.body)
  
      if sms_data['success']
        sms_recipient = sms_data['recipients'][0]['number']
        sms_status = sms_data['recipients'][0]['status']
        
        puts "Recipient: #{sms_recipient}, Status: #{sms_status}"
  
        # Save the original message and response details in your database
        Sm.create!(
          user: sms_recipient,
          message: original_message,
          status: sms_status,
          date:Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),
          system_user: 'system'
        )
        
        # Return a JSON response or whatever is appropriate for your application
        render json: { success: true, message: "Message sent successfully", recipient: sms_recipient, status: sms_status }
      else
        render json: { error: "Failed to send message: #{sms_data['message']}" }
      end
    else
      puts "Failed to send message: #{response.body}"
      render json: { error: "Failed to send message: #{response.body}" }
    end
  end












  def get_balance
    api_key = ENV['SMS_LEOPARD_API_KEY']
    api_secret = ENV['SMS_LEOPARD_API_SECRET']

    uri = URI("https://api.smsleopard.com/v1/balance")
    params = {
      username: api_key,
      password: api_secret,
     
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      puts "Your Balance #{response.body}"
      balance_data = JSON.parse(response.body)
      balance = balance_data['balance']
      render json: {message: "SMS Balance:#{balance}"},status: :ok
    else
      render json: {error: "Error Getting Balance: #{response.body}" }
      puts "Error Getting Balance: #{response.body}"
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_sm
      @sm = Sm.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sm_params
      params.require(:sm).permit(:user, :message, :admin_user)
    end
end
