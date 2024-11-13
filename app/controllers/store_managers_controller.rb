class StoreManagersController < ApplicationController
  # before_action :set_admin, only: %i[ update destroy create  ]
  before_action :set_store_manager, only: [:update, :destroy ] 
  # before_action :set_admin, except: %i[  create ]
  
# before_action :set_tenant
# set_current_tenant_through_filter



  load_and_authorize_resource except: [:verify_otp,  :login, :logout, :confirm_delivered, :confirm_delivered]
  before_action :update_last_activity, except: [:verify_otp, :logout, :login, :confirm_delivered, :confirm_received] 
  # GET /store_managers or /store_managers.json


  # before_action :set_tenant 
  # set_current_tenant_through_filter

     



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



  def index
    @store_managers = StoreManager.all
    render json: @store_managers
  end


  def update_last_activity
    if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
    end
    
  end


  def verify_otp
    @store_manager = StoreManager.find_by(manager_number: params[:manager_number])
    if  @store_manager&.verify_otp(params[:otp])
      token = generate_token(store_manager_id:  @store_manager.id)
      expires_at = 24.hours.from_now.utc

      cookies.encrypted.signed[:jwt_store_manager] = { value: token, httponly: true, secure: true , expires: expires_at , sameSite: 'strict'}
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { message: 'Invalid OTP' }, status: :unauthorized
    end
  end


  def logout
    cookies.delete(:jwt_store_manager)
    head :no_content
    # render json: { message: 'Logout successful' }, status: :ok
    # delete =  session.delete :customer_id
    # if delete
    #  head :no_content
   
    # else
    #  render json: {error: 'failed to logout'}
    # end
   end





def  confirm_delivered
 confirm_store_manager_delivered = current_store_manager.update(
  delivered_bags: true, date_delivered: Time.current.strftime('%Y-%m-%d %I:%M:%S %p'), 
received_bags: false,
number_of_bags_delivered: params[:number_of_bags_delivered] )

if confirm_store_manager_delivered

  ActionCable.server.broadcast "requests_channel", 
  {request: StoreManagerSerializer.new(current_store_manager).as_json}

  render json: {message: 'confirmation sucessful'}, status: :ok

else
  render json: {message: 'failed to confirm'}, status: :unprocessable_entity
end
end



def  confirm_received
  confirm_store_manager_received = current_store_manager.update(received_bags: true,
   date_received: Time.current.strftime('%Y-%m-%d %I:%M:%S %p'),
  delivered_bags: false,
  number_of_bags_received: params[:number_of_bags_received] )

  if  confirm_store_manager_received
    
  ActionCable.server.broadcast "requests_channel", 
  {request: StoreManagerSerializer.new(current_store_manager).as_json}

  render json: {message: 'confirmation sucessful'}, status: :ok
  else
    render json: {message: 'failed to confirm'}, status: :unprocessable_entity
  end
  end











  def login

    @store_manager = StoreManager.find_by(manager_number: params[:manager_number])

    if @store_manager
      # session[:customer_id] = @customer.id
      # render json:  {customer:  @customer} , status: :ok
      if params[:enable_2fa_for_store_manager] == true
        @store_manager.generate_otp
        if params[:send_manager_number_via_sms] == true
          send_otp(@store_manager.phone_number, @store_manager.otp, @store_manager.name)

        elsif params[:send_manager_number_via_email] == true

          StoreManagerOtpMailer.store_manager_otp(@store_manager).deliver_now
        end
      
      elsif  params[:enable_2fa_for_store_manager] == false
        token = generate_token(store_manager_id:  @store_manager.id)
        expires_at = 24.hours.from_now.utc
  
        cookies.encrypted.signed[:jwt_store_manager] = { value: token, httponly: true, secure: true , expires: expires_at }

      end
      
      render json: {store_manager:  @store_manager}, status: :ok

    else
      render json: { error: 'Invalid manager number' }, status: :unauthorized
    end
  
  end



  def create
    @store_manager = StoreManager.create(store_manager_params)
  
    if  @store_manager.save
        @prefix_and_digits = StoreManagerSetting.first
  
          found_prefix = @prefix_and_digits.prefix
          found_digits = @prefix_and_digits.minimum_digits.to_i
          Rails.logger.info "Prefix and digit relationship found"
  
          auto_generated_number = "#{found_prefix}#{@store_manager.sequence_number.to_s.rjust(found_digits, '0')}"
          @store_manager.update(manager_number: auto_generated_number)
          if params[:send_manager_number_via_email] == true 
            StoreManagerMailer.store_manager_send(@store_manager).deliver_now
          end
          
          if params[:send_manager_number_via_sms] == true
            send_sms(@store_manager.phone_number, @store_manager.manager_number)
          end

          render json:  @store_manager, status: :created
          
        
          

        
    else
      render json:  @store_manager.errors, status: :unprocessable_entity
    end
  end






  # PATCH/PUT /store_managers/1 or /store_managers/1.json
  def update
      if @store_manager.update(store_manager_params)
        render json: @store_manager
      else
         render json: @store_manager.errors, status: :unprocessable_entity 
      end
    
  end





  # DELETE /store_managers/1 or /store_managers/1.json
  def destroy
    @store_manager.destroy

    head :no_content
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_manager
      @store_manager = StoreManager.find_by(id: params[:id])
    end



    def send_otp(phone_number, otp, name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      store_manager_template = sms_template.store_manager_otp_confirmation_template
      original_message = sms_template ?  MessageTemplate.interpolate(store_manager_template,
      {otp: otp, 
      name: name})  :  "Hello #{name} use this #{otp} to continue"

      sender_id = "SMS_TEST" 
  
      uri = URI("https://api.smsleopard.com/v1/sms/send")
      params = {
        username: api_key,
        password: api_secret,
        message: original_message,
        destination: phone_number,
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
          Rails.logger.info "Message sent successfully"
          # Return a JSON response or whatever is appropriate for your application
          # render json: { success: true, message: "Message sent successfully", recipient: sms_recipient, status: sms_status }
        else
          render json: { error: "Failed to send message: #{sms_data['message']}" }
        end
      else
        Rails.logger.error "Failed to send message: #{response.body}"
        # render json: { error: "Failed to send message: #{response.body}" }
      end
    end













    def send_sms(phone_number, manager_number, name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      service_provider_template = sms_template.store_manager_manager_number_confirmation_template
      original_message = sms_template ?  MessageTemplate.interpolate(service_provider_template,
      {manager_number: manager_number, 
      name: name})  :   "Hello Welcome To QUALITY SMILES.
       Use Manager Number #{manager_number} and start using our services"

      sender_id = "SMS_TEST" # Ensure this is a valid sender ID
  
      uri = URI("https://api.smsleopard.com/v1/sms/send")
      params = {
        username: api_key,
        password: api_secret,
        message: original_message,
        destination: phone_number,
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
        # render json: { error: "Failed to send message: #{response.body}" }
      end
    end









    def authenticate_store_manager
      token = cookies.signed[:jwt]
      return render json: { error: 'Unauthorized' }, status: :unauthorized unless token
  
      # byebug 
  
  
      decoded_token = JWT.decode(token,  ENV['JWT_SECRET'], true, algorithm: 'HS256')
      store_manager_id = decoded_token[0]['store_manager_id']
      @current_store_manager = StoreManager.find_by(store_manager_id:  store_manager_id)
  
      return render json: { error: 'Unauthorized' }, status: :unauthorized unless  @current_store_manager
    rescue JWT::DecodeError, JWT::ExpiredSignature
      Rails.logger.warn  'Unauthorized'
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  






    def generate_token(payload)
      JWT.encode(payload, Rails.application.config.jwt_secret, 'HS256')
    end


    def set_admin
      @admin = Admin.find_by(id: session[:admin_id])
    Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
    Rails.logger.warn "Admin not found" unless @admin
    end


    # Only allow a list of trusted parameters through.
    def store_manager_params
      params.require(:store_manager).permit(:number_of_bags_received, :date_received, 
      :number_of_bags_delivered,
       :date_delivered, :name,
      :email, :phone_number, :store_number, :manager_number, :location, :sub_location)
    end
end
