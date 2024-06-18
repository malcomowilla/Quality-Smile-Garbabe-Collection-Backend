class SubLocationsController < ApplicationController
  before_action :set_sub_location, only: %i[ show edit update destroy ]

  # GET /sub_locations or /sub_locations.json
  def index
    @sub_locations = SubLocation.all
  end

  # GET /sub_locations/1 or /sub_locations/1.json
  def show
  end

  # GET /sub_locations/new
  def new
    @sub_location = SubLocation.new
  end

  # GET /sub_locations/1/edit
  def edit
  end

  # POST /sub_locations or /sub_locations.json
  def create
    @sub_location = SubLocation.new(sub_location_params)

    respond_to do |format|
      if @sub_location.save
        format.html { redirect_to sub_location_url(@sub_location), notice: "Sub location was successfully created." }
        format.json { render :show, status: :created, location: @sub_location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sub_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_locations/1 or /sub_locations/1.json
  def update
    respond_to do |format|
      if @sub_location.update(sub_location_params)
        format.html { redirect_to sub_location_url(@sub_location), notice: "Sub location was successfully updated." }
        format.json { render :show, status: :ok, location: @sub_location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sub_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_locations/1 or /sub_locations/1.json
  def destroy
    @sub_location.destroy!

    respond_to do |format|
      format.html { redirect_to sub_locations_url, notice: "Sub location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_location
      @sub_location = SubLocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sub_location_params
      params.require(:sub_location).permit(:name, :code, :created_by, :category)
    end
end
