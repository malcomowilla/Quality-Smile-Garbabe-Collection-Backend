class CustomersController < ApplicationController
  # before_action :set_admin
  before_action :set_admin, except: [ :login, :verify_otp, :logout, :confirm_bag, :confirm_request]
  # before_action :authenticate_customer, except: [:index, :login, :verify_otp, :logout]
  # before_action :current_customer, except: [:index, :create, :update, :destroy, :login, :verify_otp ]
before_action :current_user, only: [:confirm_bag, :confirm_request]
load_and_authorize_resource

  require "twilio-ruby"

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
    render json: @customers
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
   

def get_customer_code
@customer_login = params[:customer_login]
render json: {customer_login: @customer_login}

end





  def login
    @customer = Customer.find_by(customer_code: params[:customer_code])

    if @customer
      # session[:customer_id] = @customer.id
      # render json:  {customer:  @customer} , status: :ok
      @customer.generate_otp
      send_otp(@customer.phone_number, @customer.otp)
      render json: {customer:  @customer.customer_code}, status: :ok
    else
      render json: { error: 'Invalid customer code' }, status: :unauthorized
    end
  
  end

  # sameSite: 'strict',

  def verify_otp
    @customer = Customer.find_by(customer_code: params[:customer_code])
    if  @customer&.verify_otp(params[:otp])
      token = generate_token(customer_id:  @customer.id)
      cookies.signed[:jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { message: 'Invalid OTP' }, status: :unauthorized
    end
  end






  def create
    @customer = Customer.new(customer_params)
      if @customer.save
          @prefix_and_digits = Admin.prefix_and_digits.first
if  @prefix_and_digits.present?
  found_prefix = @prefix_and_digits.prefix
  found_digits = @prefix_and_digits.minimum_digits.to_i
else
  Rails.logger.error "prefix and digit not found"
  render json: { error: "prefix and digit not found
   for the account" }, status: :unprocessable_entity
return
end 

auto_generated_number = @customer.customer_code = "#{found_prefix}#{@customer.sequence_number.to_s.rjust(found_digits, '0')}" if
  found_digits && found_prefix 
  @customer.update(customer_code: auto_generated_number)



  render json: @customer, message: 'customer created succesfully',  status: :created
  if params[:send_sms_and_email] == true
    send_sms(@customer.phone_number, @customer.customer_code, @customer.name)
  # CustomerCodeMailer.customer_code(@customer).deliver_now


  else
    Rails.logger.info "params not received"
  end
  


      else
        render json: { errors: @customer.errors}, status: :unprocessable_entity
       
    end
  end



  def update
    customer = set_customer
      if @customer
        customer.update(customer_params)
       render json: {message: 'customer successfully updated', customer: customer}
      else
        render json: {error: 'cannot update customer'}, status: :unprocessable_entity

      end
  
  end




  def confirm_bag
    if  current_user.update(bag_confirmed: true,  confirmation_date: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
      
      formatted_time = current_user.confirmation_date.strftime('%Y-%m-%d %I:%M:%S %p')

      render json: { message: 'Bag confirmed successfully.', confirmation_date: formatted_time }, status: :ok
    else
      render json: { error: 'Failed to confirm bag.' }, status: :unprocessable_entity
    end


  end



  def confirm_request
    if current_user.update(confirm_request: true, request_date: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'), bag_confirmed: false) 
      render json: { message: 'Bag confirmed successfully.' }, status: :ok
    else
      render json: { error: 'Failed to confirm bag.' }, status: :unprocessable_entity
    end
  end






  def destroy
    @customer = set_customer
    @customer.destroy!

   head :no_content
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find_by(id: params[:id])
    end



    def set_customer_confirm
      @customer = Customer.find_by(customer_code: params[:customer_code]) 
    end
    
    
    def send_sms(phone_number, customer_code, name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      original_message = "Hello Welcome To QUALITY SMILES. Use Customer Code #{customer_code} and start using our services"
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
        render json: { error: "Failed to send message: #{response.body}" }
      end
    end





    def send_otp(phone_number, otp)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      original_message = "Hello use this #{otp} to continue"
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
        render json: { error: "Failed to send message: #{response.body}" }
      end
    end



  # def authenticate_customer
  #   token = cookies.signed[:jwt]
  #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

  #   # byebug 


  #   decoded_token = JWT.decode(token,  ENV['JWT_SECRET'], true, algorithm: 'HS256')
  #   customer_id = decoded_token[0]['customer_id']
  #   @current_customer = Customer.find_by(id: customer_id)

  #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_customer
  # rescue JWT::DecodeError, JWT::ExpiredSignature
  #   Rails.logger.warn  'Unauthorized'
  #   render json: { error: 'Unauthorized' }, status: :unauthorized
  # end



    def generate_token(payload)
      JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end



  def set_admin
    @admin = Admin.find_by(id: session[:admin_id])
  Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
  Rails.logger.warn "Admin not found" unless @admin
  end



    def customer_params
      params.require(:customer).permit(:name, :email, :phone_number, :location, :customer_code, :amount_paid, :date, 
      :date_registered, :request_date, :confirmation_date
      )
    end
end
