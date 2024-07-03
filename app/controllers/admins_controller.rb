class AdminsController < ApplicationController
  # before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
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




  
def login
  @admin = Admin.find_by(email:params[:email] ) || Admin.find_by(phone_number:params[:phone_number]) 
  if params[:login_with_otp] === true 
    if @admin&.authenticate(params[:password])
      @admin.generate_otp
      send_otp(@admin.phone_number, @admin.otp)
      render json: {admin: @admin.user_name}, status: :accepted
    else
  
      render json: {error: 'Invalid Username Or Password' }, status: :unauthorized
    end
  else
if  @admin&.authenticate(params[:password])
  session[:admin_id] = @admin.id
  render json: {admin: @admin.user_name}, status: :accepted

else
  render json: {error: 'Invalid Username Or Password' }, status: :unauthorized
    end
end
  
 
end




def verify_otp
  @admin = Admin.find_by(email: params[:email])
  if  @admin&.verify_otp(params[:otp])
    session[:admin_id] = @admin.id
        render json: {admin: @admin.user_name}, status: :accepted

  else
    render json: { message: 'Invalid OTP' }, status: :unauthorized
  end
end




def logout
 delete =  session.delete :admin_id
 if delete
  head :no_content

 else
  render json: {error: 'failed to logout'}
 end
end

  # POST /admins or /admins.json
  def create
    @admin = Admin.create(admin_params)

    
  if @admin.valid?
    # session[:account_id] =  @account.id
    render json: { admin: AdminSerializer.new(@admin) }, status: :created
  else
    render json: { errors: @admin.errors }, status: :unprocessable_entity
  end
  end



  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admin_url(@admin), notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy!

    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find_by(params[:id])
    end



    def send_otp(phone_number, otp)
      api_key = ENV['SMS_LEOPARD_API_KEY']
      api_secret = ENV['SMS_LEOPARD_API_SECRET']
      message = "Hello use this #{otp} to continue"
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


    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:user_name, :phone_number,:email, :password, :password_confirmation,)

    end



end



