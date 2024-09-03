class LocationsController < ApplicationController
  before_action :set_location, only: %i[   update destroy ]
before_action :update_last_activity


  load_and_authorize_resource

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
