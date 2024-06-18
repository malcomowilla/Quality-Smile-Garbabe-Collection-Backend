class AdminsController < ApplicationController
  # before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end



  # GET /admins/1/edit
  def edit
  end


def login
  @admin = Admin.find_by(email:params[:email] ) || Admin.find_by(phone_number:params[:phone_number] ) 
  if @admin&.authenticate(params[:password])
    session[:admin_id] = @admin.id
    render json: {admin: @admin.user_name}, status: :accepted
  else

    render json: {error: 'Invalid Username Or Password' }, status: :unauthorized
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
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:user_name, :phone_number,:email, :password, :password_confirmation,)

    end



end



