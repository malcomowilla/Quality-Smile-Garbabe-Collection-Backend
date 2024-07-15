class AdminsController < ApplicationController

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'message_template'

  
        def index
          @admins = Admin.all
          render json: @admins
        end



        def create_admins
          @admin = Admin.new(admin_params)
          # email_valid = Truemail.validate(params[:email])
        
          @admin.password = SecureRandom.base64(8) 
          @admin.password_confirmation = @admin.password 
        @admin.skip_password_validation = true
          if params[:role].blank?
            render json: { error: "Role cannot be empty" }, status: :unprocessable_entity
            return
          end
        
          # unless email_valid.result.valid?
          #   render json: { error: "Invalid email format or domain" }, status: :unprocessable_entity
          #   return
          # end
          if @admin.save
            @admin.update(
              role: params[:role],
              date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),
              can_read_sms_templates: params[:can_read_sms_templates],
              can_manage_sms_templates: params[:can_manage_sms_templates],
              can_read_sms:  params[:can_read_sms],
              can_manage_sms:  params[:can_manage_sms],
              can_read_finances_account: params[:can_read_finances_account],
              can_manage_finances_account: params[:can_manage_finances_account],
              can_read_invoice: params[:can_read_invoice],
              can_manage_invoice: params[:can_manage_invoice],
              can_read_sub_location: params[:can_read_sub_location],
              can_manage_sub_location: params[:can_manage_sub_location],
              can_read_location: params[:can_read_location],
              can_manage_location: params[:can_manage_location],
              can_read_store_manager: params[:can_read_store_manager],
              can_manage_store_manager: params[:can_manage_store_manager],
              can_read_store: params[:can_read_store],
              can_manage_store: params[:can_manage_store],
              can_read_service_provider: params[:can_read_service_provider],
              can_manage_service_provider: params[:can_manage_service_provider],
              can_manage_customers: params[:can_manage_customers],
              can_read_customers: params[:can_read_customers],
              can_read_settings: params[:can_read_settings],
              can_manage_settings: params[:can_manage_settings],
              can_manage_payment: params[:can_manage_payment],
              can_read_payment: params[:can_read_payment]
            )
            # send_login_password(@admin.phone_number, @admin.password, @admin.user_name)
            render json: @admin, status: :created
            
          else
            render json: { errors: @admin.errors }, status: :unprocessable_entity
            
          end
       
        end
        
     



  def forgot_password
   
    if  @admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])
      @admin.generate_password_reset_token
      ResetPasswordMailer.password_forgotten(@admin).deliver_now
      render json: {message: 'email sent'}, status: :ok
    else
      render json: {error:'email not found'}, status: :unprocessable_entity
    end
  end



  def reset_password
    @admin = Admin.find_by(reset_password_token: params[:token])
    if params[:password] == params[:password_confirmation]
      if params[:password].match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$/) 
    if @admin&.password_token_valid?
      if @admin.reset_password(params[:password])
        render json: {message: 'password has been updated succesfully'}, status: :ok
      else
        render json: {error: 'failed to update password'}, status: :unprocessable_entity
      end
    else
      render json: {error: 'invalid or expired token please reset your password again'}, status: :unprocessable_entity
    end
  else

    render json: {error: "must include at least one lowercase letter, one uppercase letter, one digit,
             and needs to be minimum 12 characters."}, status: :unprocessable_entity
  end
    else
        render json: {error: 'password and password confirmation do not match'}, status: :unprocessable_entity
    end
    
  end


  def user
    if current_user
     
      # CurrentUserJob.perform_at(current_user, 2.seconds.from_now
       
      # )
       
      # CurrentUserJob.perform_later(current_user.id)
      # ActionCable.server.broadcast(current_user, { user: current_user.user_name })
      # CurrentUserChannel.broadcast_to(current, { user: current_user.user_name })
      
      render json: { user: current_user }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end



  
def login
  @admin = Admin.find_by(email:params[:email] ) || Admin.find_by(phone_number:params[:phone_number]) 
  if params[:login_with_otp] === true 
    if @admin&.authenticate(params[:password])
      @admin.generate_otp
           send_otp(@admin.phone_number, @admin.otp)
           render json:  @admin, serializer: AdminSerializer,   status: :accepted

    else
  
      render json: {error: 'Invalid Username Or Password' }, status: :unauthorized
    end
  else
if  @admin&.authenticate(params[:password])
  # session[:admin_id] = @admin.id
  token = generate_token(admin_id: @admin.id)
  cookies.signed[:jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}

  render json:  @admin, serializer: AdminSerializer,   status: :accepted

else
  render json: {error: 'Invalid Email Or Password' }, status: :unauthorized
    end
end
  
 
end




def verify_otp
  @admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])
  if  @admin&.verify_otp(params[:otp])
    # session[:admin_id] = @admin.id
     token = generate_token(admin_id: @admin.id)
  cookies.signed[:jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i , sameSite: 'strict'}
        render json: {admin: @admin.user_name}, status: :accepted

  else
    render json: { message: 'Invalid OTP' }, status: :unauthorized
  end
end




def logout
#  delete =  session.delete :admin_id
#  if delete
#   head :no_content

#  else
#   render json: {error: 'failed to logout'}
#  end
 cookies.delete(:jwt)
head :no_content
end

  # POST /admins or /admins.json
  def create
    @admin = Admin.create(admin_params)

    
  if @admin.valid?
    @admin.update(date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),)
    # session[:account_id] =  @account.id
    render json: { admin: AdminSerializer.new(@admin) }, status: :created
  else
    render json: { errors: @admin.errors }, status: :unprocessable_entity
  end
  end


  def update_user
find_user
    @admin.skip_password_validation = true
    if @admin.update(role: params[:role],
      can_manage_sms_templates: params[:can_manage_sms_templates],
      can_read_sms_templates: params[:can_read_sms_templates],
              can_manage_sms:  params[:can_manage_sms],
              can_read_sms:  params[:can_read_sms],
      can_read_finances_account: params[:can_read_finances_account],
      can_manage_finances_account: params[:can_manage_finances_account],
      can_read_invoice: params[:can_read_invoice],
      can_manage_invoice: params[:can_manage_invoice],
      can_read_sub_location: params[:can_read_sub_location],
      can_manage_sub_location: params[:can_manage_sub_location],
      can_read_location: params[:can_read_location],
      can_manage_location: params[:can_manage_location],
      can_read_store_manager: params[:can_read_store_manager],
      can_manage_store_manager: params[:can_manage_store_manager],
      can_read_store: params[:can_read_store],
      can_manage_store: params[:can_manage_store],
      can_read_service_provider: params[:can_read_service_provider],
      can_manage_service_provider: params[:can_manage_service_provider],
      can_manage_customers: params[:can_manage_customers],
      can_read_customers: params[:can_read_customers],
      can_read_settings: params[:can_read_settings],
      can_manage_settings: params[:can_manage_settings],
      can_manage_payment: params[:can_manage_payment],
      can_read_payment: params[:can_read_payment])
     
      render json: @admin, status: :ok
    else
      render json: @admin.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update_admin
      if @admin.update(admin_params)
        render json: @admin, status: :ok
      else
        render json: @admin.errors, status: :unprocessable_entity 
      end
    
  end





  # DELETE /admins/1 or /admins/1.json
  def delete_user
    find_user
    @admin.destroy!

   
       head :no_content 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
   
    def generate_token(payload)
      JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
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
          # render json: { success: true, message: "Message sent successfully", recipient: sms_recipient, status: sms_status }
        else
          # render json: { error: "Failed to send message: #{sms_data['message']}" }
           puts  "Failed to send message: #{sms_data['message']}"
        end
      else
        puts "Failed to send message: #{response.body}"
        # render json: { error: "Failed to send message: #{response.body}" }
      end
    end



    def send_login_password(phone_number, password, user_name)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      admin_template = sms_template.user_invitation_template
      original_message = sms_template ?  MessageTemplate.interpolate(admin_template,{password: password, 
      user_name: user_name})  :   "Hello, use this #{password} as your password 
      to invite yourself and start using our services"
      sender_id = "SMS_TEST"
      sms_leopard_status_secret = ENV['SMS_LEOPARD_SECRET_KEY']
      status_url = "https://700f-102-68-79-197.ngrok-free.app/sms_status_message"
      uri = URI("https://api.smsleopard.com/v1/sms/send")
    
      params = {
        username: api_key,
        password: api_secret,
        message: original_message,
        destination: phone_number,
        source: sender_id,
        status_url: status_url,
        status_secret: sms_leopard_status_secret
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
         puts "Recipient: #{sms_recipient}, Status: #{sms_status}"
        else
          # render json: { error: "Failed to send message: #{sms_data['message']}" }
          puts "Failed to send message: #{sms_data['message']}"
        end
      else
        puts "Failed to send message: #{response.body}"
        # render json: { error: "Failed to send message: #{response.body}" }
      end
    end


    def admin_update_params
      params.permit(
        :can_manage_sms_templates,
        :can_read_sms_templates,
        :can_manage_sms,
        :can_read_sms,
        :role,
        :can_read_finances_account,
        :can_manage_finances_account,
        :can_read_invoice,
        :can_manage_invoice,
        :can_read_sub_location,
        :can_manage_sub_location,
        :can_read_location,
        :can_manage_location,
        :can_read_store_manager,
        :can_manage_store_manager,
        :can_read_store,
        :can_manage_store,
        :can_read_service_provider,
        :can_manage_service_provider,
        :can_manage_customers,
        :can_read_customers,
        :can_read_settings,
        :can_manage_settings,
        :can_manage_payment,
        :can_read_payment
      )
    end
    

def find_user
  @admin = Admin.find_by(id: params[:id])
end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:user_name, :phone_number,:email, :password, :password_confirmation,  :can_read_finances_account, 
      :can_manage_finances_account,:can_read_invoice, :can_manage_invoice, :can_read_sub_location, :can_manage_sub_location, 
      :can_manage_sub_location, :can_read_location, :can_manage_location, :can_read_store_manager, :can_manage_store_manager,
      :can_read_store, :can_manage_store, :can_read_service_provider, :can_manage_service_provider, :can_manage_customers,
      :can_read_customers, :can_read_settings, :can_manage_settings, :can_manage_payment, :can_read_payment, :role,
      :can_manage_sms_templates,:can_read_sms_templates,
      :can_read_sms,
        :can_manage_sms,
      )

    end



end



