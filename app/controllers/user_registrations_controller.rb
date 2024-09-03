class UserRegistrationsController < ApplicationController



  def register_webauthn

    @admin = find_or_initialize_user(params[:email], params[:user_name])
    @admin.skip_password_validation = true
    @admin.password = SecureRandom.base64(8) 
    @admin.password_confirmation = @admin.password
    if @admin.save
      if @admin.webauthn_id.nil?
        @admin.update!(webauthn_id: WebAuthn.generate_user_id[0..32], 
  
  
        date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
      end
  
      # admin.update(date_registered: Time.now.strftime('%Y-%m-%d %I:%M:%S %p'),)
      options = WebAuthn::Credential.options_for_create(
        user: { id: Base64.urlsafe_encode64(@admin.webauthn_id), name: @admin.user_name || @admin.email },
        exclude: @admin.credentials.map { |c| c.webauthn_id },
        # authenticator_selection: { authenticator_attachment: 'cross-platform' }, # Use cross-platform authenticator
  
        # authenticator_selection: { authenticator_attachment: 'platform' }, # Ensure it's using platform authenticator (e.g., phone)
  
        # rp: { name: 'quality_smiles', id: '0b53-102-68-79-195.ngrok-free.app'  }
  
      )
  
      # yourdevice cant be used with this site, localhost may require a new kind of device
      # encoded_challenge = Base64.urlsafe_encode64(options.challenge)
  
      session[:webauthn_registration] = options.challenge
      Rails.logger.info "Challenge during registration:#{session[:webauthn_registration]}"
  
  
      render json: options, status: :ok
    else
      render json: @admin.errors , status: :unprocessable_entity
    end
  end
  
  
  
  
  
  
  
  def create_webauthn
   
  
    begin
      Rails.logger.info "Received params: #{params.inspect}"
      Rails.logger.info "challenge during verification: #{session[:webauthn_registration].inspect}"
  
      webauthn_credential = WebAuthn::Credential.from_create(params[:credential])
      admin = find_passkey_user(params[:email], params[:user_name])
  
      # Check if the session data is present
      if session[:webauthn_registration].blank?
      Rails.logger.warn "Session data for webauthn_registration is missing or nil"
      end 
  
      
      webauthn_credential.verify(
      session[:webauthn_registration],
      
      )
      admin.credentials.create!(
        webauthn_id: webauthn_credential.id,
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count,
        # authenticator_selection: { authenticator_attachment: 'platform' }, # Ensure it's using platform authenticator (e.g., phone)
  
        # rp: { name: 'quality-smiles'}
  
      )
      render json: { message: 'WebAuthn registration successful' }, status: :ok
    rescue WebAuthn::Error => e
      puts "WebAuthn Error: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
      
    end
  end
  



end
