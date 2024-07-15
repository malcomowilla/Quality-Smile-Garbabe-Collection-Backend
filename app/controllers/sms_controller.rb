class SmsController < ApplicationController
  load_and_authorize_resource

  # GET /sms or /sms.json
  def index
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
  def create
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
    @sm.destroy!

    respond_to do |format|
      format.html { redirect_to sms_url, notice: "Sm was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

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
