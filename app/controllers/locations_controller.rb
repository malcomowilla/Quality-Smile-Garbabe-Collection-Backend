class LocationsController < ApplicationController
before_action :update_last_activity

set_current_tenant_through_filter

  load_and_authorize_resource

  before_action :set_tenant 

   
  # def set_tenant
  #   random_name = "Tenant-#{SecureRandom.hex(4)}"
  #   @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain, name: random_name)
      
  #   set_current_tenant(@account)
   
  #  end


  def set_tenant
  
  
    @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])
    
    if @account.nil?
      Rails.logger.error "No account found for subdomain: #{request.headers['X-Original-Host']}"
      render json: { error: 'Invalid tenant' }, status: :not_found
      return
    end
  
    set_current_tenant(@account)
  end

  # def set_tenant
  #   @account = Account.find_or_create_by(subdomain: request.subdomain)
  
  #   set_current_tenant(@account)
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Invalid tenant' }, status: :not_found
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




  # GET /locations or /locations.json
  def index
    @locations = Location.all
    render json: @locations
  end


  def update_last_activity
    if current_user.instance_of?(Admin)
      current_user.update_column(:last_activity_active, Time.now.strftime('%Y-%m-%d %I:%M:%S %p'))
    end
    
  end
  

  def create
    @location = Location.create(location_params)


    if @location.save
      render json:  @location, status: :created
    else
      render json: @location.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
      if @location.update(location_params)
        render json: @location, status: :ok
      else
        render json: @location.errors, status: :unprocessable_entity
      end
    
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

        head :no_content
   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:location_name, :sub_location, :location_code, :category)
    end



end
