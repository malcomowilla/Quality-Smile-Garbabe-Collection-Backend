class PrefixAndDigitsForServiceProvidersController < ApplicationController

  # GET /prefix_and_digits_for_service_providers or /prefix_and_digits_for_service_providers.json
  def index
    @prefix_and_digits_for_service_providers = PrefixAndDigitsForServiceProvider.all
  end

  # GET /prefix_and_digits_for_service_providers/1 or /prefix_and_digits_for_service_providers/1.json
  def show
  end

  # GET /prefix_and_digits_for_service_providers/new
  def new
    @prefix_and_digits_for_service_provider = PrefixAndDigitsForServiceProvider.new
  end

  # GET /prefix_and_digits_for_service_providers/1/edit
  def edit
  end

  # POST /prefix_and_digits_for_service_providers or /prefix_and_digits_for_service_providers.json
  def create
    @prefix_and_digits_for_service_provider = PrefixAndDigitsForServiceProvider.new(prefix_and_digits_for_service_provider_params)

    respond_to do |format|
      if @prefix_and_digits_for_service_provider.save
        format.html { redirect_to prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider), notice: "Prefix and digits for service provider was successfully created." }
        format.json { render :show, status: :created, location: @prefix_and_digits_for_service_provider }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_service_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefix_and_digits_for_service_providers/1 or /prefix_and_digits_for_service_providers/1.json
  def update
    respond_to do |format|
      if @prefix_and_digits_for_service_provider.update(prefix_and_digits_for_service_provider_params)
        format.html { redirect_to prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider), notice: "Prefix and digits for service provider was successfully updated." }
        format.json { render :show, status: :ok, location: @prefix_and_digits_for_service_provider }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_service_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefix_and_digits_for_service_providers/1 or /prefix_and_digits_for_service_providers/1.json
  def destroy
    @prefix_and_digits_for_service_provider.destroy!

    respond_to do |format|
      format.html { redirect_to prefix_and_digits_for_service_providers_url, notice: "Prefix and digits for service provider was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefix_and_digits_for_service_provider
      @prefix_and_digits_for_service_provider = PrefixAndDigitsForServiceProvider.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prefix_and_digits_for_service_provider_params
      params.require(:prefix_and_digits_for_service_provider).permit(:prefix, :minimum_digits)
    end
end
