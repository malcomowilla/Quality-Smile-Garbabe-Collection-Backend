class DevicesController < ApplicationController
  before_action :set_device, only: %i[ show update destroy ]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    if @device.save
      render :show, status: :created, location: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    if @device.update(device_params)
      render :show, status: :ok, location: @device
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:admin_id, :os, :ip_address, :device_token, :last_seen_at)
    end
end
