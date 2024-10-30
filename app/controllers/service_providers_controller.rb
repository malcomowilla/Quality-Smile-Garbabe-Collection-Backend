class ServiceProvidersController < ApplicationController
  before_action :set_admin, except: [ :login, :verify_otp, :logout, :confirm_collected, :confirm_delivered]

# before_action :authenticate_service_provider, except: [:index, :create, :update, :destroy, :login, :verify_otp ]
before_action :current_user, only: [:confirm_collected, :confirm_delivered]

before_action :update_last_activity, except: [:login, :logout, :verify_otp, :confirm_collected, :confirm_delivered] 
load_and_authorize_resource except: [:login, :logout, :verify_otp, :confirm_collected, :confirm_delivered]
before_action :set_tenant 
set_current_tenant_through_filter


  def index
    @service_providers = ServiceProvider.all
    render json: @service_providers
  end


  def set_tenant
    set_current_tenant(current_user.account)
  

end

  def update_last_activity
    if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
    end
    
  end
  


  def login

    @service_provider = ServiceProvider.find_by(provider_code: params[:provider_code])

    if @service_provider
      # session[:service_provider_id] = @service_provider.id
      # render json:  {service_provider:   @service_provider} , status: :ok
      
      
      render json: {service_provider:  @service_provider.provider_code}, status: :ok

      if params[:enable_2fa_for_service_provider]
        @service_provider.generate_otp
        if params[:send_sms_and_email_for_provider] == true || params[:send_sms_and_email_for_provider] == 'true'
          send_otp(@service_provider.phone_number, @service_provider.otp, @service_provider.name)
        end
      
        if params[:send_email_for_provider] == true || params[:send_email_for_provider] == 'true'
          
          ServiceProviderOtpMailer.provider_otp(@service_provider).deliver_now

        end

      else
        token = generate_token(service_provider_id:  @service_provider.id)
        cookies.encrypted.signed[:service_provider_jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}
      

      end
    else
      render json: { error: 'Invalid provider code' }, status: :unauthorized
    end
  
  end





  def logout
    cookies.delete(:service_provider_jwt)
    head :no_content
    # render json: { message: 'Logout successful' }, status: :ok
    # delete =  session.delete :customer_id
    # if delete
    #  head :no_content
   
    # else
    #  render json: {error: 'failed to logout'}
    # end
   end



   def verify_otp
    @service_provider = ServiceProvider.find_by(provider_code: params[:provider_code])
    if  @service_provider&.verify_otp(params[:otp])
      token = generate_token(service_provider_id:  @service_provider.id)
      cookies.encrypted.signed[:service_provider_jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { message: 'Invalid OTP' }, status: :unauthorized
    end
  end



  def confirm_collected
    if current_service_provider.update(collected: true, date_collected: 
      Time.current.strftime('%Y-%m-%d %I:%M:%S %p'), delivered: false,
                 ) 

  ActionCable.server.broadcast "requests_channel", 
  {request: ServiceProviderSerializer.new(current_service_provider).as_json}

      render json: { message: 'Bag confirmed successfully.' }, status: :ok
    else
      render json: { error: 'Failed to confirm bag.' }, status: :unprocessable_entity
    end
  end






  def confirm_delivered

    if  current_service_provider.update(delivered: true,  date_delivered:
       Time.current.strftime('%Y-%m-%d %I:%M:%S %p'), collected: false,
      )
      
  ActionCable.server.broadcast "requests_channel", 
  {request: ServiceProviderSerializer.new(current_service_provider).as_json}
      render json: { message: 'Bag confirmed successfully.', }, status: :ok
    else
      render json: { error: 'Failed to confirm bag.' }, status: :unprocessable_entity
    end


  end









  def create
    @service_provider = ServiceProvider.new(service_provider_params)
    

      if @service_provider.save
     
       
          @prefix_and_digits = PrefixAndDigitsForServiceProvider.first
if  @prefix_and_digits.present?
  found_prefix = @prefix_and_digits.prefix
  found_digits = @prefix_and_digits.minimum_digits.to_i
else
  Rails.logger.error "prefix and digit not found"
  render json: { error: "prefix and digit not found
   for the account" }, status: :unprocessable_entity
return
end 

auto_generated_number =  @service_provider.provider_code = "#{found_prefix}#{@service_provider.sequence_number.to_s.rjust(found_digits, '0')}" if
found_digits && found_prefix 

  @service_provider.update(provider_code: auto_generated_number)



  render json: @service_provider,   status: :created
if params[:send_email_for_provider] == true
  ServiceProviderMailer.service_provider_code(@service_provider).deliver_now
end
  
  if params[:send_sms_and_email_for_provider] == true
    send_sms(@service_provider.phone_number, @service_provider.provider_code, @service_provider.name)
  

  else
    Rails.logger.info "params not received"
  end


        
      else
        render json: {errors: @service_provider.errors}, status: :unprocessable_entity
       
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end












  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    @service_provider = set_service_provider
      if @service_provider
        @service_provider.update(service_provider_params)
       render json: {message: 'service provider successfully updated', service_provider: @service_provider}
      else
        render json: {error: 'cannot update service provider'}, status: :unprocessable_entity

      end
  
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @service_provider = set_service_provider
    @service_provider.destroy!

   head :no_content
  end


  private
    def set_service_provider
      @customer = ServiceProvider.find_by(id: params[:id])
    end





  # def authenticate_service_provider
  #   token = cookies.signed[:jwt]
  #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

  #   # byebug 


  #   decoded_token = JWT.decode(token,  ENV['JWT_SECRET'], true, algorithm: 'HS256')
  #   service_provider_id = decoded_token[0]['service_provider_id']
  #   @service_provider = ServiceProvider.find_by(id: service_provider_id)

  #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless @service_provider
  # rescue JWT::DecodeError, JWT::ExpiredSignature
  #   Rails.logger.warn  'Unauthorized'
  #   render json: { error: 'Unauthorized' }, status: :unauthorized
  # end



    def send_sms(phone_number, provider_code, name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      service_provider_template = sms_template.service_provider_confirmation_code_template
      original_message = sms_template ?  MessageTemplate.interpolate(service_provider_template,
      {provider_code: provider_code, 
      name: name})  :   "Hello #{name} Welcome To QUALITY SMILES. Use Service Provider Code #{provider_code} and start using our services"

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







    def send_otp(phone_number, otp, name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      service_provider_template = sms_template.service_provider_otp_confirmation_template
      original_message = sms_template ?  MessageTemplate.interpolate(service_provider_template,
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














    def generate_token(payload)
      JWT.encode(payload, Rails.application.config.jwt_secret, 'HS256')
    end




  def set_admin
    @admin = Admin.find_by(id: session[:admin_id])
  Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
  Rails.logger.warn "Admin not found" unless @admin
  end

    def service_provider_params
      params.require(:service_provider).permit(:phone_number, :name, 
      :email, :provider_code, :status, :date_registered, :location)
    end


end



