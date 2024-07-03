class StoreManagersController < ApplicationController
  before_action :set_admin, only: %i[ update destroy create  ]
  before_action :set_store_manager, only: [:update, :destroy ] 
  # before_action :set_admin, except: %i[  create ]

  # GET /store_managers or /store_managers.json
  def index
    @store_managers = StoreManager.all
    render json: @store_managers
  end




  def verify_otp
    @store_manager = StoreManager.find_by(manager_number: params[:manager_number])
    if  @store_manager&.verify_otp(params[:otp])
      token = generate_token(store_manager_id:  @store_manager.id)
      expires_at = 24.hours.from_now.utc

      cookies.signed[:jwt] = { value: token, httponly: true, secure: true , expires: expires_at , sameSite: 'strict'}
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { message: 'Invalid OTP' }, status: :unauthorized
    end
  end


  def logout
    cookies.delete(:jwt)
    head :no_content
    # render json: { message: 'Logout successful' }, status: :ok
    # delete =  session.delete :customer_id
    # if delete
    #  head :no_content
   
    # else
    #  render json: {error: 'failed to logout'}
    # end
   end














  def login

    @store_manager = StoreManager.find_by(manager_number: params[:manager_number])

    if @store_manager
      # session[:customer_id] = @customer.id
      # render json:  {customer:  @customer} , status: :ok
      @store_manager.generate_otp
      send_otp(@store_manager.phone_number, @store_manager.otp)
      render json: {store_manager:  @store_manager.manager_number}, status: :ok
      send_otp(@store_manager.phone_number, @store_manager.otp)

    else
      render json: { error: 'Invalid manager number' }, status: :unauthorized
    end
  
  end



  def create
    @store_manager = StoreManager.create(store_manager_params)
  
    if  @store_manager.save
      if @admin.respond_to?(:prefix_and_digits_for_store_managers)
        @prefix_and_digits = @admin.prefix_and_digits_for_store_managers.first
  
        if @prefix_and_digits.present?
          found_prefix = @prefix_and_digits.prefix
          found_digits = @prefix_and_digits.minimum_digits.to_i
          Rails.logger.info "Prefix and digit relationship found"
  
          auto_generated_number = "#{found_prefix}#{@store_manager.sequence_number.to_s.rjust(found_digits, '0')}"
          @store_manager.update(manager_number: auto_generated_number)
  
          render json:  @store_manager, status: :created
          send_sms(@store_manager.phone_number, @store_manager.manager_number)

        else
          Rails.logger.info "Prefix and digit relationship not found"
          render json: { error: "Prefix and digit not found for the account" }, status: :unprocessable_entity
        end
      else
        Rails.logger.info "Admin does not respond to prefix_and_digits_for_stores"
        render json: { error: "Admin does not have prefix and digits for stores" }, status: :unprocessable_entity
      end
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





    def send_otp(phone_number, otp)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      message = "Hello Welcome To QUALITY SMILES. Use This Password #{otp} and start using our services"
      sender_id = "SMS_TEST" # Ensure this is a valid sender ID
  
      uri = URI("https://api.smsleopard.com/v1/sms/send")
      params = {
        username: api_key,
        password: api_secret,
        message: message,
        destination: phone_number,
        source: sender_id
      }
      uri.query = URI.encode_www_form(params)
  
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        puts "Message sent successfully"
      else
        puts "Failed to send message: #{response.body}"
      end
    end






 
    def send_sms(phone_number, manager_number)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      message = "Hello Welcome To QUALITY SMILES. Use Manager Number #{manager_number} and start using our services"
      sender_id = "SMS_TEST" # Ensure this is a valid sender ID
  
      uri = URI("https://api.smsleopard.com/v1/sms/send")
      params = {
        username: api_key,
        password: api_secret,
        message: message,
        destination: phone_number,
        source: sender_id
      }
      uri.query = URI.encode_www_form(params)
  
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        puts "Message sent successfully"
      else
        puts "Failed to send message: #{response.body}"
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
      params.require(:store_manager).permit(:number_of_bags_received, :date_received, :number_of_bags_delivered,
       :date_delivered, :name,
      :email, :phone_number, :store_number, :manager_number, :location, :sub_location)
    end
end
