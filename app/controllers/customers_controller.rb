class CustomersController < ApplicationController
  # before_action :set_admin
        # before_action :set_admin, except: [ :login, :verify_otp, :logout, :confirm_bag, :confirm_request]
  # before_action :authenticate_customer, except: [:index, :login, :verify_otp, :logout]
  # before_action :current_customer, except: [:index, :create, :update, :destroy, :login, :verify_otp ]
      # before_action :current_user, except: [:confirm_bag, :confirm_request]
      set_current_tenant_through_filter

      before_action :update_last_activity, except: [:logout, :login, :verify_otp,
       :confirm_bag, :confirm_request, 
    ]

    before_action :set_tenant 

        load_and_authorize_resource except: [:verify_otp,  :login, 
        :logout, :confirm_bag, :confirm_request, :my_current_customer,
        :get_customer_code, :get_my_customer_code, :get_current_customer
      ]

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'message_template'
  require "twilio-ruby"



  def set_tenant
    @account = Account.find_or_create_by(subdomain: request.subdomain)
  
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end






   
  # def set_tenant
  #   random_name = "Tenant-#{SecureRandom.hex(4)}"
  #   @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain, name: random_name)
      
  #   set_current_tenant(@account)
   
  #  end





  # def set_tenant
  #   if current_user.present? && current_user.account.present?
  #     set_current_tenant(current_user.account)
  #   else
  #     Rails.logger.debug "No tenant or current_user found"
  #     # Optionally, handle cases where no tenant is set
  #     raise ActsAsTenant::Errors::NoTenantSet
  #   end
  # end
  
  # GET /customers or /customers.json
  def index
    @customers = Customer.all
    render json: @customers
  end


  def get_all_customers
    @customers = Customer.all
    render json: @customers
  end



def my_current_customer
  if current_customer

    customer_name = current_customer.name
    support_ticket = SupportTicket.find_by(customer:  customer_name)

    render json: [customer: support_ticket], status: :ok
  else
    render json: {customer_error_message: "customer not found"}, status: :not_found
  end
end





  
def get_my_customer_code
  
end


  def update_last_activity
if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
    end
    
  end
       




  def logout
    cookies.delete(:customer_jwt)
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


# CustomerOtpMailer





def get_current_customer
  if current_customer
    render json: current_customer, status: :ok
  else
    render json: {error: 'no customer logged in'}, status: :unauthorized
  end
end







  def login
    @customer = Customer.find_by(customer_code: params[:customer_code]) || Customer.find_by(customer_code: params[:my_customer_code
  ])

    if @customer
      # session[:customer_id] = @customer.id
      # render json:  {customer:  @customer} , status: :ok
      
      if params[:enable_2fa] == true || params[:enable_2fa] == 'true'
        @customer.generate_otp
        render json: {customer:  @customer.customer_code}, status: :ok
      if params[:send_email] == true || params[:send_email] == 'true'
        CustomerOtpMailer.customers_otp(@customer).deliver_now
      end

      if params[:send_sms_and_email] == true || params[:send_sms_and_email] == 'true'
        @customer.generate_otp
        send_otp(@customer.phone_number, @customer.name, @customer.otp)
      end
      else
        token = generate_token(customer_id:  @customer.id)
      cookies.encrypted.signed[:customer_jwt] = { value: token, httponly: true,
       secure: true , exp: 24.hours.from_now.to_i , }
      end
      
      
    else
      render json: { error: 'Invalid customer code' }, status: :unauthorized
    end
  
  end

  # sameSite: 'strict',

  def verify_otp
    @customer = Customer.find_by(customer_code: params[:customer_code])
    if  @customer&.verify_otp(params[:otp])
      token = generate_token(customer_id:  @customer.id)
      cookies.encrypted.signed[:customer_jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}
      render json: { message: 'Login successful' }, status: :ok

      
    else
      render json: { message: 'Invalid OTP' }, status: :unauthorized
    end
  end






  def create
    @customer = Customer.new(customer_params)
      if @customer.save
          # @prefix_and_digits = Admin.prefix_and_digits.first
          @prefix_and_digits = CustomerSetting.first
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


if params[:send_email] == true || params[:send_email] == 'true'
  CustomerCodeMailer.customer_code(@customer).deliver_now
end


  if params[:send_sms_and_email] == true || params[:send_email] == 'true'
    send_sms(@customer.phone_number, @customer.customer_code, @customer.name)


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
    customer_confirm =  current_customer.update(bag_confirmed: true, 
       confirmation_date: Time.current.strftime('%Y-%m-%d %I:%M:%S %p'),
       confirm_request: false)
    if customer_confirm
      
      # Rails.logger.info "current customer =>#{current_customer.confirmation_date.strftime('%Y-%m-%d %I:%M:%S %p')}"
       ActionCable.server.broadcast "requests_channel", 
       {request: CustomerSerializer.new(current_customer).as_json}
      render json: { message: 'Bag confirmed successfully.'}, status: :ok
    else
      render json: { error: 'Failed to confirm bag.' }, status: :unprocessable_entity
    end


  end



  def confirm_request

customer_request = current_customer.update(confirm_request: true, request_date: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),
bag_confirmed: false)

    if customer_request 
      Rails.logger.info "customer_request=>#{customer_request}" 
       ActionCable.server.broadcast "requests_channel", 
       {request: CustomerSerializer.new(current_customer).as_json}
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
      sms_template = SmsTemplate.first
      customer_template = sms_template.customer_confirmation_code_template
      original_message = sms_template ?  MessageTemplate.interpolate(customer_template,{customer_code: customer_code, 
      name: name})  :   "Hello Welcome To QUALITY SMILES. Use Customer Code #{customer_code} and start using our services"
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
          # render json: { success: true, message: "Message sent successfully", recipient: sms_recipient, status: sms_status }
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
      customer_template = sms_template.customer_otp_confirmation_template
      original_message = sms_template ?  MessageTemplate.interpolate(customer_template,{otp: otp, 
      name: name})  :   "Hello, #{name} use this #{otp} as your password 
       and start using our services"
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
          # render json: { success: true, message: "Message sent successfully", recipient: sms_recipient, status: sms_status }
        else
          render json: { error: "Failed to send message: #{sms_data['message']}" }
        end
      else
        puts "Failed to send message: #{response.body}"
        # render json: { error: "Failed to send message: #{response.body}" }
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



  # def set_admin
  #   @admin = Admin.find_by(id: session[:admin_id])
  # Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
  # Rails.logger.warn "Admin not found" unless @admin
  # end



    def customer_params
      params.require(:customer).permit(:name, :email, :phone_number, 
      :location, :customer_code, :amount_paid, :date, 
      :date_registered, :request_date, :confirmation_date
      )
    end
end
