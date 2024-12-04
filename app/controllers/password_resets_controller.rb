class PasswordResetsController < ApplicationController
  # before_action :set_tenant 
  # set_current_tenant_through_filter
ActsAsTenant.without_tenant do
  def create
    @admin = Admin.find_by(email: params[:email]) 
    
    if @admin
      # Generate a secure random password
      new_password = generate_secure_password(16) # generates a 16-character random string
      
      if @admin.update(password: new_password)
        # Send the new password via email
        AdminMailer.password_reset(@admin, new_password).deliver_now
        render json: { message: 'Password has been reset. Check your email for the new password.' }, status: :ok
      else
        render json: { error: 'Failed to reset password' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No user found with that email or phone number' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: 'An error occurred while resetting password' }, status: :internal_server_error
  end
end
  private

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








  def set_tenant
    @account = Account.find_by(subdomain: request.headers['X-Original-Host'])
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end
end
