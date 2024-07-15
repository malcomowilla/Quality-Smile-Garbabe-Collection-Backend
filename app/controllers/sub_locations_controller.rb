class SubLocationsController < ApplicationController
  before_action :set_sub_location, only: %i[ show edit update destroy ]



  load_and_authorize_resource

  # GET /sub_locations or /sub_locations.json
  def index
    @sub_locations = SubLocation.all
    render json: @sub_locations
  end




  # POST /sub_locations or /sub_locations.json
  def create
    @sub_location = SubLocation.create(sub_location_params)

      if @sub_location.save
        render json: @sub_location, status: :created
      else
        render json: @sub_location.errors, status: :unprocessable_entity
      end
    
  end

  # PATCH/PUT /sub_locations/1 or /sub_locations/1.json
  def update
      if @sub_location.update(sub_location_params)
     render json: @sub_location
      else
              render json: @sub_location.errors, status: :unprocessable_entity
      end
  end



  # DELETE /sub_locations/1 or /sub_locations/1.json
  def destroy
    @sub_location.destroy!
      head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_location
      @sub_location = SubLocation.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sub_location_params
      params.require(:sub_location).permit(:name, :code, :created_by, :category)
    end
end
