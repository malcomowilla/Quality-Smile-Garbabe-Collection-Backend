class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy ]
# before_action :set_admin, only: %i[ create show edit update destroy ]
before_action :update_last_activity
# before_action :set_tenant
load_and_authorize_resource
# set_current_tenant_through_filter



def update_last_activity
  if current_user.instance_of?(Admin)
    current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
  end
  
end





before_action :set_tenant 
set_current_tenant_through_filter

   



def set_tenant
  @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])

  set_current_tenant(@account)
rescue ActiveRecord::RecordNotFound
  render json: { error: 'Invalid tenant' }, status: :not_found
end




# def set_tenant
#   if current_user.present? && current_user.account.present?
#     set_current_tenant(current_user.account)
#   else
#     Rails.logger.debug "No tenant or current_user found"
#     # Optionally, handle cases where no tenant is set
#     raise ActsAsTenant::Errors::NoTenantSet
#   end
# end

  # GET /stores or /stores.json
  def index

    @stores = Store.all
    render json: @stores

    
  end



  def create
    @store = Store.new(store_params)
  
    if @store.save
        @prefix_and_digits = PrefixAndDigitsForStore.first
  
          found_prefix = @prefix_and_digits.prefix
          found_digits = @prefix_and_digits.minimum_digits.to_i
          Rails.logger.info "Prefix and digit relationship found"
  
          auto_generated_number = "#{found_prefix}#{@store.sequence_number.to_s.rjust(found_digits, '0')}"
          @store.update(store_number: auto_generated_number)
  
          render json: @store, status: :created
       
     
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end
  




  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    @store  = set_store
    if  @store.update(store_params)
      render json: {store: @store}, status: :ok
    else


      render json: {error: 'failed to update store please try again later'}
    end
   
  end





  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.destroy!
    head :no_content
 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find_by(id: params[:id])
    end



  def set_admin
    @admin = Admin.find_by(id: session[:admin_id])
  Rails.logger.info "Admin found: #{@admin.inspect}" if @admin
  Rails.logger.warn "Admin not found" unless @admin
  end
    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:amount_of_bags, :status, :from_store, :location, :store_number, :sub_location)
    end


end
