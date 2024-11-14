class AdminsController < ApplicationController

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'message_template'
require 'webauthn'

set_current_tenant_through_filter


before_action :set_tenant 

before_action :update_last_activity, only: [:create_admins, :logout ]


def update_last_activity
    current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
  
end
    
def set_tenant
  
  @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])

  @admin = Admin.first
  Rails.logger.info "My tenant account: #{@admin.inspect}" # Log the first admin
  set_current_tenant(@account)
 
rescue ActiveRecord::RecordNotFound
  render json: { error: 'Invalid tenant' }, status: :not_found
end

# def set_tenant
#   set_current_tenant(current_user.account)


# end


# def set_tenant
#   Rails.logger.debug "Request Domain: #{request.domain}, Subdomain: #{request.subdomain}"
  
#   # Find or create the account based on the current domain and subdomain
#   @account = Account.find_or_create_by(domain: request.domain, subdomain: request.subdomain) do |account|
#     account.name = "Tenant-#{SecureRandom.hex(4)}" # Set name only if creating a new account
#   end

#   set_current_tenant(@account)
# end

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
          @admins = Admin.all
          render json: @admins
        end

        def get_my_admins
  #         limit = params[:limit].to_i
  # offset = params[:offset].to_i
  # admins = Admin.offset(offset).limit(limit)
  # has_more = admins.size == limit
  # render json: { admins: admins, has_more: has_more }
   @admins = Admin.all
  render json: @admins
        end


        def show_conversation
          @other_admin = Admin.find_by(id: params[:id])
          @messages = Message.where(sender: current_user, receiver: @other_admin)
                             .or(Message.where(sender: @other_admin,
                              receiver: current_user))
      
          render json: @messages
        end


        def allow_get_updated_admin
          admin = Admin.find_by(id: params[:id])
          render json: {
            id: admin.id,
            email: admin.email,
            user_name: admin.user_name,
            # profile_image: admin.profile_image.attached? ? url_for(admin.profile_image) : nil,
            phone_number: admin.phone_number
          }
        end

        


        def get_updated_admin
          render json: {
            id: current_user.id,
            email: current_user.email,
            user_name: current_user.user_name,
            profile_image: current_user.profile_image.attached? ? url_for(current_user.profile_image) : nil,
            phone_number: current_user.phone_number
          }
        end


        def create_admins
          @my_admin = Admin.new(admin_params)
          # email_valid = Truemail.validate(params[:email])
          validate_invite_admin
           @my_admin.password = SecureRandom.hex(8) 
          # my_password = @my_admin.generate_login_password
          if params[:role].blank?
            render json: { error: "Role cannot be empty" }, status: :unprocessable_entity
            return
          end
        
          # unless email_valid.result.valid?
          #   render json: { error: "Invalid email format or domain" }, status: :unprocessable_entity
          #   return
          # end
          # 
          #
            # t.string "can_manage_calendar"
    # t.string "can_read_calendar"
    # 
     if @my_admin.errors.empty?
          if @my_admin.save
            @my_admin.update(
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
              can_read_payment: params[:can_read_payment],
              can_manage_calendar: params[:can_manage_calendar],
              can_read_calendar: params[:can_read_calendar]
            )

            # webauthn_options = WebAuthn::Credential.options_for_create(
            #   user: { id: @admin.webauthn_id, name: @admin.email || @admin.user_name },
            #   exclude: @admin.credentials.map { |c| c.webauthn_id }
            # )
        
            # session[:webauthn_registration] = webauthn_options.challenge
            # 
            
            
            if params[:send_password_via_sms] == true || params[:send_password_via_sms] == 'true'
              send_login_password(@my_admin.phone_number, @my_admin.password, @my_admin.user_name)
            end

            if params[:send_password_via_email] == true || params[:send_password_via_email] == 'true'
              AdminPasswordMailer.admins_password(@my_admin).deliver_now
            end

            if params[:login_with_web_auth] == true ||  params[:login_with_web_auth] == 'true'
              Rails.logger.info "Enqueuing GenerateWebAuthnOptionsJob for admin: #{@my_admin.email}"

              GenerateWebAuthnOptionsJob.perform_now(@my_admin)

              # invitation_link = "http://localhost:5173/web_authn_registration?&email=#{@my_admin.email}"
              # UserInviteMailer.user_invite(@my_admin, invitation_link).deliver_now
            end
            
            render json: @my_admin, status: :created
            
          else
            render json: { errors: @my_admin.errors }, status: :unprocessable_entity
            
          end

        else
          render json: { errors: @my_admin.errors }, status: :unprocessable_entity
          
        end
       
        end
        
     




def find_my_email
 admin =  Admin.find_by(email: params[:my_email])
  if admin 
    Rails.logger.info "email params: #{params[:my_email]}"

  else
    Rails.logger.info "Admin not found"
  end
end



def create_fcm_token
 token_saved =  current_user.update_column(:fcm_token, params[:fcm_token])

  if token_saved 
    render json: {message: 'token saved'}, status: :ok
  else
    render json: {error: 'something went wrong please try again'},status: :unprocessable_entity
  end
  
end


# generate_password_reset_token(admin)

  def forgot_password
    company_subdomain = request.headers['X-Original-Host']
    @company_name = CompanySetting.first&.company_name
    # @company_photo = CompanySetting.first.logo.attached? ? url_for(CompanySetting.first.logo) : nil
    if  @admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])
      @admin.generate_password_reset_token(@admin)
      PasswordResetMailer.password_reset(@admin,  company_subdomain).deliver_now
      # ResetPasswordMailer.password_forgotten(@admin).deliver_now
      render json: {message: 'email sent'}, status: :ok
    else
      render json: {error:'email not found'}, status: :unprocessable_entity
    end
  end

  # reset_password(password, admin)

  def reset_password
    @admin = Admin.find_by(reset_password_token: params[:token])
    if params[:password] == params[:password_confirmation]
      if params[:password].match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$/) 
    if @admin&.password_token_valid?
      if @admin.reset_password(params[:password], @admin)
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

  admin = Admin.find_by(email: params[:email]) 


  if params[:enable_2fa_for_admin] == true || params[:enable_2fa_for_admin] == 'true' 
    if admin&.authenticate(params[:password])
    
    #  admin.update_column(inactive: false)
    if params[:login_with_otp] == true  || params[:login_with_otp] == 'true'
      admin.generate_otp(admin)

      send_otp(params[:phone_number], admin.otp, admin.user_name)
    end
        render json: {message: 'sms sent'}, status: :ok
        # token = generate_token(admin_id: admin.id)

        # cookies.encrypted.signed[:jwt] = { value: token, httponly: true, secure: true,
        # sameSite: 'strict'}

          #  admin.update_column(:last_login_at, Time.current)

          #  render json:  admin, serializer: AdminSerializer,   status: :accepted
    else
  
      render json: {error: 'Invalid  Email Or Password' }, status: :unauthorized
      return
    end
  if params[:login_with_otp_email] == true || params[:login_with_otp_email] == ''

     admin.generate_otp(admin)
    #  token = generate_token(admin_id: admin.id)
    #  cookies.signed[:jwt] = { value: token, httponly: true, secure: true,
    # sameSite: 'strict'}
      
admin.update_column(:inactive, false)
admin.update_column(:last_activity_active, Time.zone.now)
     AdminOtpMailer.admins_otp(admin).deliver_now
    
          #  admin.update(last_login_at: Time.current)

# render json:  admin, serializer: AdminSerializer,   status: :accepted
   
  end
  else
    
if admin&.authenticate(params[:password])
  
  # session[:admin_id] = @admin.id
  token = generate_token(admin_id: admin.id)
  cookies.encrypted.signed[:jwt] = { value: token, httponly: true, secure: true,
 sameSite: 'strict'}
  admin.update_column(:last_login_at, Time.now)
  # admin.update_column(:inactive, false)
  admin.update_column(:last_activity_active, Time.zone.now)
  admin.update_column(:inactive, false)
  # admin.update_column(:last_activity_active, Time.zone.now )
  render json:  admin, serializer: AdminSerializer,   status: :accepted

else
  render json: {error: 'Invalid Email Or Password' }, status: :unauthorized
    end
end
  
end


  
# def login
#   @admin = Admin.find_by(email:params[:email] ) || Admin.find_by(phone_number:params[:phone_number]) 
#   if @admin&.authenticate(params[:password])
#     current_device = request.user_agent
#     if @admin.current_device != current_device 
#       # Device is unrecognized
#        @admin.generate_otp
#       send_otp(@admin.phone_number, @admin.device_token)
#       render json: { message: 'OTP sent to your phone. Please verify.', device_token: @admin.device_token }, status: :accepted
#     else
#       # Device recognized
#       token = generate_token(admin_id: @admin.id)
#       cookies.signed[:jwt] = { value: token, httponly: true, secure: true, exp: 24.hours.from_now.to_i, sameSite: 'strict' }
#       @admin.update(last_login_ip: request.remote_ip, last_login_at: Time.current, current_device: current_device)
#       render json: @admin, serializer: AdminSerializer, status: :accepted
#     end
#   else
#     render json: { error: 'Invalid Email Or Password' }, status: :unauthorized
#   end
 
# end
 



def invite_register_with_webauthn
Rails.logger.info   "received email from react =>#{params[:my_email]}"
  admin =  Admin.find_by(email: params[:my_email])

  if admin.nil?
    Rails.logger.error "Admin not found for email: #{params[:my_email]} and user_name: #{params[:user_name]}"
    render json: { error: 'Admin not found' }, status: :not_found
    return
  end
  # admin.skip_password_validation = true
  # admin.password = SecureRandom.base64(8) 
    if admin.webauthn_id.nil?
      admin.update!(webauthn_id: WebAuthn.generate_user_id[0..32], 


    )
    end

    # admin.update(date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),)
    options = WebAuthn::Credential.options_for_create(
      user: { id: Base64.urlsafe_encode64(admin.webauthn_id), name: admin.user_name || admin.email },
      exclude: admin.credentials.map { |c| c.webauthn_id },
      # authenticator_selection: { authenticator_attachment: 'cross-platform' }, # Use cross-platform authenticator

      # authenticator_selection: { authenticator_attachment: 'platform' }, # Ensure it's using platform authenticator (e.g., phone)

      # rp: { name: 'quality_smiles', id: '0b53-102-68-79-195.ngrok-free.app'  }

    )

    # yourdevice cant be used with this site, localhost may require a new kind of device
    # encoded_challenge = Base64.urlsafe_encode64(options.challenge)

    session[:webauthn_registration] = options.challenge
    Rails.logger.info "Challenge during registration:#{session[:webauthn_registration]}"


    render json: options, status: :ok
  
end



def register_webauthn
  @the_admin = find_or_initialize_user(params[:user_name])
  validate_admin_passkey_user_name

  if @the_admin.errors.empty?
    if @the_admin.save
      if @the_admin.webauthn_id.nil?
        @the_admin.update!(webauthn_id: WebAuthn.generate_user_id[0..32], date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
      end

      relying_party = WebAuthn::RelyingParty.new(
        origin: "https://#{request.headers['X-Original-Host']}",
        name: "aitechs",
        id: request.headers['X-Original-Host']
      )

      options =  relying_party.options_for_registration(
        user: { id: Base64.urlsafe_encode64(@the_admin.webauthn_id), name: @the_admin.user_name || @the_admin.email },
        exclude: @the_admin.credentials.map(&:webauthn_id)
      )

      # Set the challenge in the session
      session[:webauthn_registration] = options.challenge
      Rails.logger.info "Challenge during registration: #{session[:webauthn_registration]}"

      render json: options, status: :ok
    else  
      render json: @the_admin.errors, status: :unprocessable_entity
    end
  else  
    render json: @the_admin.errors, status: :unprocessable_entity
  end
end




def create_webauthn
  begin
    Rails.logger.info "Received params: #{params.inspect}"

    relying_party = WebAuthn::RelyingParty.new(
      origin: "https://#{request.headers['X-Original-Host']}",
      name: "aitechs",
      id: request.headers['X-Original-Host']
    )

    challenge = params[:credential][:challenge]


    webauthn_credential = relying_party.verify_registration(
      params[:credential],
      challenge
      
      )
    admin = Admin.find_by(user_name: params[:user_name]) || Admin.find_by(email: params[:email])
    # Check if the session data is present

    if challenge.blank?
      Rails.logger.warn "Challenge is missing from the request"
      render json: { error: "Challenge is missing" }, status: :unprocessable_entity
      return
    end 

    # if session[:webauthn_registration].blank?
    #   Rails.logger.warn "Session data for webauthn_registration is missing or nil"
    #   render json: { error: "Challenge is missing" }, status: :unprocessable_entity
    #   return
    # end 

    # Verify the credential
    # webauthn_credential.verify(session[:webauthn_registration])
    # webauthn_credential.verify(challenge)
    admin.credentials.create!(
      webauthn_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )

    # session[:webauthn_registration] = nil
    render json: { message: 'WebAuthn registration successful' }, status: :ok
  rescue WebAuthn::Error => e
    Rails.logger.error "WebAuthn Error: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
  end
end


def authenticate_webauthn
  # "id": ""AdVZRNnFYkuE-z2ExPy7YNCjTEbBPiGqJHJ0DSMW8d_3H63vtT5dcjFWa_QUp5bNTimc5J3_SSXIeFVuUeAbxTo",
  # "5TR0TJqgdKRNuqsDhDQV6L7ccHct5B_xGUJ1HJWp0G4" =>  chalenge,
  admin = find_passkey_user(params[:user_name])


  relying_party = WebAuthn::RelyingParty.new(
    origin: "https://#{request.headers['X-Original-Host']}",
    name: "aitechs",
    id: request.headers['X-Original-Host']
  )

  if admin.present?
    options = relying_party.options_for_authentication(allow: admin.credentials.map { |c| c.webauthn_id })
    # admin_credentials = admin.credentials.map do |credential|
    #   {  id: Base64.urlsafe_encode64(credential.webauthn_id) }
    # end

    # options = WebAuthn::Credential.options_for_get(
    #   allow: admin_credentials,
    # )
    
   
    session[:authentication_challenge] = options.challenge
    Rails.logger.info "Challenge during authentication: #{session[:authentication_challenge]}"

    render json: options
    # render json:  @admin, serializer: AdminSerializer,   status: :accepted
  else
    render json: {error: 'username or email not found'}, status: :not_found

  end

end



def verify_webauthn
  # Initialize the Relying Party with the appropriate origin and name
  relying_party = WebAuthn::RelyingParty.new(
    origin: "https://#{request.headers['X-Original-Host']}",
    name: "aitechs",
    id: request.headers['X-Original-Host']
  )

  # Find the admin user based on the provided username
  admin = find_passkey_user(params[:user_name])

  # Extract the challenge from the incoming credential
  challenge = params[:credential][:challenge]

  # Check if the challenge is present
  if challenge.blank?
    Rails.logger.warn "Challenge is missing from the request"
    render json: { error: "Challenge is missing" }, status: :unprocessable_entity
    return
  end 

  begin
    # Find the stored credential for the admin
    stored_credential = admin.credentials.find_by(webauthn_id: params[:credential][:id])

    Rails.logger.info "Stored credentials for #{admin.email}: #{stored_credential.inspect}"

    if stored_credential.nil?
      render json: { error: 'Your Passkey Not Found. Please Signup First' }, status: :not_found
      return
    end

    # Verify the credential using the relying party
    relying_party.verify_authentication(
      challenge,
      # params[:credential],
      public_key: stored_credential.public_key,
      sign_count: stored_credential.sign_count
    )

    # Update admin's last activity and login time
    admin.update_column(:inactive, false)
    admin.update_column(:last_activity_active, Time.zone.now)
    admin.update_column(:last_login_at, Time.now)

    # Generate a token and set it in cookies
    token = generate_token(admin_id: admin.id)
    cookies.encrypted.signed[:jwt] = { value: token, httponly: true, secure: true, exp: 24.hours.from_now.to_i, sameSite: 'strict' }

    # Update the sign count for the stored credential
    stored_credential.update!(sign_count: stored_credential.sign_count)

    render json: { message: 'WebAuthn authentication successful' }, status: :ok
  rescue WebAuthn::Error => e
    Rails.logger.error "WebAuthn Error: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
  end
end










def verify_otp

  # admin.update_column(:inactive, false)
  
  admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])
  if  admin&.verify_otp(params[:otp])
    # session[:admin_id] = @admin.id
     token = generate_token(admin_id: admin.id)
     cookies.encrypted.signed[:jwt] = { value: token, httponly: true, secure: true , exp: 24.hours.from_now.to_i }
  # admin.update_column(inactive: false, last_activity_active: Time.zone.now)
  admin.update_column(:inactive, false)
  admin.update_column(:last_activity_active, Time.zone.now)
  admin.update_column(:last_login_at, Time.now)
        render json: {admin: admin.user_name}, status: :accepted

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
    @admin = Admin.new(admin_params)
  
    # Manually apply your custom validations
    validate_admin_data
  
    if @admin.errors.empty?
      @admin.date_registered = Time.now.strftime('%Y-%m-%d %I:%M:%S %p')
      
      if @admin.save
        render json: { admin: AdminSerializer.new(@admin) }, status: :created
      else
        render json: { errors: @admin.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: @admin.errors}, status: :unprocessable_entity
    end
  
  end

  def update_user
admin = find_user
    # @admin.skip_password_validation = true
    if admin.update_columns(role: params[:role],
      email: params[:email],
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
      can_read_payment: params[:can_read_payment],
      can_manage_tickets: params[:can_manage_tickets],
      can_read_tickets: params[:can_read_tickets], 
      can_manage_calendar: params[:can_manage_calendar],
              can_read_calendar: params[:can_read_calendar]
    )
      render json: admin, status: :ok
    else
      render json: admin.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update_admin
    @admin = find_admin
    
    # Skip password validation if set to true
    @admin.skip_password_validation = true
  
    if @admin.update(admin_params)
      render json: {
        id: @admin.id,
        user_name: @admin.user_name,
        profile_image_url: @admin.profile_image.attached? ? url_for(@admin.profile_image) : nil,
        email: @admin.email,
        phone_number: @admin.phone_number
      }
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


    def find_admin
      @admin = Admin.find_by(id: params[:id])
    end

    def find_a_user(email)
      Admin.find_by(email: email) 
    end


    def find_or_initialize_user(user_name)
  # Admin.new(email: email, user_name: user_name)  
  # && Admin.find_by(email: email, user_name: user_name) 
  
  
    Admin.find_or_initialize_by(user_name: user_name)

    end
    
    def find_passkey_user(user_name)
      Admin.find_by(user_name: user_name)
    end




    def send_otp(phone_number, otp, user_name)
      Rails.logger.info "sending otp"
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      sms_template = SmsTemplate.first
      admin_template = sms_template.admin_otp_confirmation_template
      original_message = sms_template ?  MessageTemplate.interpolate(admin_template,{otp: otp, 
      user_name: user_name})  :   "Hello, #{user_name} use this #{otp} as your password 
       and start using our services"
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
        :can_read_tickets,
        :can_manage_tickets,
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
        :can_read_payment,
        :can_manage_calendar,
        :can_read_calendar
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
      :can_manage_sms_templates,:can_read_sms_templates,:can_read_tickets,
      :can_manage_tickets,
      :can_manage_calendar,
        :can_read_calendar,
      :can_read_sms,
        :can_manage_sms,
        :profile_image
      )

    end



def validate_invite_admin
  if params[:user_name].blank?
    @my_admin.errors.add(:user_name, "can't be blank")
  end

  if params[:email].blank?
    @my_admin.errors.add(:email, "can't be blank")
  elsif !params[:email].match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
    @my_admin.errors.add(:email, "is not a valid email")
  elsif Admin.exists?(email: params[:email])
    @my_admin.errors.add(:email, "has already been taken")
  end

end




def validate_admin_passkey_user_name
  # Check user_name presence
  if params[:user_name].blank? || params[:user_name] == ''
    @the_admin.errors.add(:user_name, "can't be blank")
  end


  

end







    def validate_admin_data
      # Check user_name presence
      if params[:user_name].blank?
        @admin.errors.add(:user_name, "can't be blank")
      end
    

      # Check password presence and complexity
      if params[:password].present?
        unless params[:password].match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$/)
          @admin.errors.add(:password, "must include at least one lowercase letter, one uppercase letter, one digit, and be at least 12 characters long.")
        end
      
    
      if Admin.exists?(user_name: params[:user_name])
        @admin.errors.add(:user_name, "has already been taken")
      end 
      #Check email presence and format
      if params[:email].blank?
        @admin.errors.add(:email, "can't be blank")
      elsif !params[:email].match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
        @admin.errors.add(:email, "is not a valid email")
      elsif Admin.exists?(email: params[:email])
        @admin.errors.add(:email, "has already been taken")
      end
    
      # Validate password confirmation
      if params[:password_confirmation].blank?
        @admin.errors.add(:password_confirmation, "can't be blank")
      elsif params[:password] != params[:password_confirmation]
        @admin.errors.add(:password_confirmation, "doesn't match Password")
      end
    end
  end
  end






