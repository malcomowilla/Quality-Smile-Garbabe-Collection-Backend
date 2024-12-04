class SystemAdminsController < ApplicationController
    # before_action :set_system_admin, only: %i[ show update destroy ]
  
    require 'webauthn'
  
  
  
    ActsAsTenant.without_tenant do
  
    
      def check_passkey_status
        admin = SystemAdmin.find_by(email: session[:admin_email])
        if admin
          render json: { passkeyExists: admin.system_admin_credentials.any? }, status: :ok
        else
          render json: { error: 'SystemAdmin not found.' }, status: :not_found
        end
      end
    
  
  def check_email_already_verified
    admin = SystemAdmin.find_by(email: session[:admin_email])
    if admin
      render json: { email_verified: admin.email_verified }, status: :ok
    else
      render json: { error: 'SystemAdmin not found.' }, status: :not_found
    end
  end
  
      # ... existing methods ...
    
  
  
  
  
  
  
  
    def register_webauthn_system_admin
  
      @the_admin = find_or_initialize_user_sys_admin(params[:email])
      if params[:email].blank?
        render json: { error: "Email cannot be empty" }, status: :unprocessable_entity
        return
      end
  
  
      if @the_admin.errors.empty?
        if @the_admin.save
          if @the_admin.webauthn_id.nil?
            @the_admin.update!(webauthn_id: WebAuthn.generate_user_id[0..32])
          end
    
          relying_party = WebAuthn::RelyingParty.new(
            # origin: "https://#{request.headers['X-Original-Host']}" ,
             origin: "http://localhost:5173",
            name: "aitechs",
            id: 'localhost'
            # id: request.headers['X-Original-Host']
          )
    
          options =  relying_party.options_for_registration(
            user: { id: Base64.urlsafe_encode64(@the_admin.webauthn_id), name: @the_admin.user_name || @the_admin.email },
            # exclude: @the_admin.credentials.map(&:webauthn_id)
            exclude: @the_admin.system_admin_credentials.map(&:webauthn_id)
          )
    
          # Set the challenge in the session
          session[:webauthn_registration] = options.challenge
          Rails.logger.info "Challenge during registration:
           #{session[:webauthn_registration]}"
    
          render json: options, status: :ok
        else  
          render json: @the_admin.errors, status: :unprocessable_entity
        end
      else  
        render json: @the_admin.errors, status: :unprocessable_entity
      end
    end
    
    
  
  
  
  
  
    def validate_invite_super_admin
      # Initialize @my_admin if it hasn't been initialized yet
    
  
  
  
      
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
    
    def invite_company_super_admins
      validate_invite_super_admin
    
      # Initialize @my_admin with the provided parameters
      @my_admin = Admin.find_or_create_by(
        user_name: params[:user_name],
        email: params[:email],
        phone_number: params[:phone_number]
      )
    
  
  
      @my_admin.password = generate_secure_password(16)
      # admin_account = Account.find_or_create_by(subdomain: params[:company_domain_or_subdomain])
      
      # @my_admin.account = admin_account
      @my_admin.role = 'super_administrator'
    
      if @my_admin.errors.empty?
        if @my_admin.save
          AdminPasswordMailer.admins_password(@my_admin).deliver_now
          render json: @my_admin, status: :created
        else
          render json: { errors: @my_admin.errors }, status: :unprocessable_entity
        end
      else
        render json: { errors: @my_admin.errors }, status: :unprocessable_entity
      end
    end
  
  
    
    
    def login_email
      admin = SystemAdmin.find_by(email: params[:email])
      
      if admin
        # Check if the admin's email is already verified
        if !admin.email_verified
          # Generate a verification token and send the email only if not verified
          admin.generate_email_verification_token(admin)
          SystemAdminMailer.system_admin(admin).deliver_now
          
          # Create a session to indicate that the email has been verified
          session[:admin_email] = admin.email
          render json: { email: admin.email }, status: :ok
        else
          # If already verified, just prompt for password
          session[:admin_email] = admin.email
          render json: { message: 'Email already verified. Please provide your password.' }, status: :ok
        end
      else
        render json: { error: 'Email not found.' }, status: :not_found
      end
    end
  
  
    # Step 2: Login with Password
    def login_email_password
      admin = SystemAdmin.find_by(email: session[:admin_email]) # Retrieve the admin using the stored email
  
      if params[:token].present?
  
          admin_verify_token = SystemAdmin.find_by(verification_token: params[:token])
  
  
          if admin_verify_token
          
              if admin&.authenticate(params[:password])
                admin.update(email_verified: true, verification_token: nil) # Clear the token after verification
          session[:is_email_verified] = admin.email_verified
                # Create a session or token for the admin
                # token = generate_token(admin_id: admin.id) # Assuming you have a method to generate a token
                # cookies.encrypted.signed[:jwt_sys_admin] = { value: token, httponly: true, secure: true, exp: 24.hours.from_now.to_i, sameSite: 'strict' }
                
                render json: { message: 'Logged in successfully', role: admin.role }, status: :ok
              else
                render json: { error: 'Invalid password.' }, status: :unauthorized
              end
          
            else
              render json: { error: 'Invalid or expired verification token.' }, status: :unauthorized
          
            end
        
      else
        if admin.email_verified
          if admin.authenticate(params[:password])
            # Create a session or token for the admin
            # token = generate_token(admin_id: admin.id) # Assuming you have a method to generate a token
            # cookies.encrypted.signed[:jwt_sys_admin] = { value: token, httponly: true, secure: true, exp: 24.hours.from_now.to_i, sameSite: 'strict' }
            
            render json: { message: 'Logged in successfully', role: admin.role }, status: :ok
          else
            render json: { error: 'Invalid password.' }, status: :unauthorized
          end
        else
          render json: { error: 'Email not verified. Please verify your email first.' }, status: :unauthorized
        end
  
      end
      end
  
    
  
  
  
  
  
  
  
  
  def get_current_sys_admin_email
    @sys_admin_email = session[:admin_email]
  if @sys_admin_email
  render json: @sys_admin_email, status: :ok
  else
    render json: 'system admin email session is nil', status: :not_found
  end
  
  end
  
    
  
  
  def create_webauthn_sys_admin
    sys_admin = SystemAdmin.find_by(email: params[:email]) 
    
  
    begin
  
      relying_party = WebAuthn::RelyingParty.new(
        # origin: "https://#{request.headers['X-Original-Host']}",
        origin: "http://localhost:5173",
        name: "aitechs",
        # id: request.headers['X-Original-Host']
        id: "localhost"
      )
  
      challenge = params[:credential][:challenge]
  
  
      webauthn_credential = relying_party.verify_registration(
        params[:credential],
        challenge
        
        )
      # Check if the session data is present
      unless sys_admin
        render json: { error: 'SystemAdmin not found.' }, status: :not_found
        return
      end
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
  
      # sys_admin.credentials.create
  
      sys_admin.system_admin_credentials.create!(
        webauthn_id: webauthn_credential.id,
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )
  
      # session[:webauthn_registration] = nil
      render json: { message: 'WebAuthn registration successful' },
       status: :ok
    rescue WebAuthn::Error => e
      Rails.logger.error "WebAuthn Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  
    
  
  
  
  
  
  def authenticate_webauthn_system_admin
    # "id": ""AdVZRNnFYkuE-z2ExPy7YNCjTEbBPiGqJHJ0DSMW8d_3H63vtT5dcjFWa_QUp5bNTimc5J3_SSXIeFVuUeAbxTo",
    # "5TR0TJqgdKRNuqsDhDQV6L7ccHct5B_xGUJ1HJWp0G4" =>  chalenge,
    admin = find_passkey_user_sys_admin(params[:email])
  
  
    relying_party = WebAuthn::RelyingParty.new(
      # origin: "https://#{request.headers['X-Original-Host']}",
      origin: "http://localhost:5173",
      name: "aitechs",
      # id: request.headers['X-Original-Host']
      id: "localhost"
    )
  
    if admin.present?
      options = relying_party.options_for_authentication(allow: 
      admin.system_admin_credentials.map { |c| c.webauthn_id })
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
  
    
  
  
  
  
  
  
  def verify_webauthn_sys_admin
    # Initialize the Relying Party with the appropriate origin and name
    relying_party = WebAuthn::RelyingParty.new(
      # origin: "https://#{request.headers['X-Original-Host']}",
      origin: "http://localhost:5173",
      name: "aitechs",
      id: "localhost"
      # id: request.headers['X-Original-Host']
    )
  
  
    public_key_credential = params[:credential]
    if public_key_credential.nil?
      Rails.logger.warn "PublicKeyCredential is missing from the request"
      render json: { error: "PublicKeyCredential is missing" }, status: :unprocessable_entity
      return
    end
  
    # Find the admin user based on the provided username
    admin = find_passkey_user_sys_admin(params[:email])
  
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
      # stored_credential = admin.credentials.find_by(webauthn_id: params[:credential][:id])
  
  
      webauthn_credential, stored_credential = relying_party.verify_authentication(
        public_key_credential,
        challenge
      ) do |webauthn_credential|
        # Find the stored credential based on the external ID
        admin.system_admin_credentials.find_by(webauthn_id: webauthn_credential.id)
      end
      Rails.logger.info "Stored credentials for #{admin.email}: #{stored_credential.inspect}"
  
      # webauthn_credential = WebAuthn::Credential.from_get(params[:credential])
  
  
      # # Verify the credential using the relying party
      # relying_party.verify_authentication(
      #   challenge,
      #   # params[:credential],
      #   webauthn_credential
      # )
  
    
      # Generate a token 
  
      token = generate_token(admin_id: admin.id) # Assuming you have a method to generate a token
      cookies.encrypted.signed[:jwt_sys_admin] = { value: token, httponly: true, secure: true, exp: 24.hours.from_now.to_i, sameSite: 'strict' }
      
  admin.update(role: 'system_administrator')
      # Update the sign count for the stored credential
      stored_credential.update!(sign_count: webauthn_credential.sign_count)
  
      render json: { message: 'WebAuthn authentication successful' }, status: :ok
    rescue WebAuthn::Error => e
      Rails.logger.error "WebAuthn Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  
  
  
  
  def sys_admin
    if current_sys_admin
  
      # CurrentUserJob.perform_at(current_user, 2.seconds.from_now
       
      # )
       
      # CurrentUserJob.perform_later(current_user.id)
      # ActionCable.server.broadcast(current_user, { user: current_user.user_name })
      # CurrentUserChannel.broadcast_to(current, { user: current_user.user_name })
      
      render json: { user: SystemAdminSerializer.new(current_sys_admin) }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  
  
  def logout_system_admin
  
    cookies.delete(:jwt_sys_admin)
   head :no_content
     
   end
  
  
    private
      # Use callbacks to share common setup or constraints between actions.
    
  
  
  
  
      def validate_admin_passkey_user_name
        # Check user_name presence
        if params[:email].blank? || params[:email] == ''
          @the_admin&.errors.add(:email, "can't be blank")
      
          
        end
      
      
        
      
      end
  
  
  
  
  
  
      def find_or_initialize_user_sys_admin(email)
        SystemAdmin.find_by(email: email)
      end
    
      def find_passkey_user_sys_admin(email)
        SystemAdmin.find_by(email: email)
      end
    
      def generate_token(payload)
        JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
      end
    
      def system_admin_params
        params.require(:system_admin).permit(:user_name, :password_digest, :email)
      end
  
  
  
      def generate_secure_password(length = 12)
        raise ArgumentError, 'Length must be at least 8' if length < 8
      
        # Define the character sets
        lowercase = ('a'..'z').to_a
        uppercase = ('A'..'Z').to_a
        digits = ('0'..'9').to_a
        symbols = %w[! @ # $ % ^ & * ( ) - _ = + { } [ ] | : ; " ' < > , . ? /]
      
        # Combine all character sets
        all_characters = lowercase + uppercase + digits + symbols
      
        # Ensure the password contains at least one character from each set
        password = []
        password << lowercase.sample
        password << uppercase.sample
        password << digits.sample
        password << symbols.sample
      
        # Fill the rest of the password length with random characters from all sets
        (length - 4).times { password << all_characters.sample }
      
        # Shuffle the password to ensure randomness
        password.shuffle!
      
        # Join the array into a string
        password.join
      end
  
  
  
  
    end
  
  end