class PrefixAndDigitsForStoreManagersController < ApplicationController
  before_action :set_prefix_and_digits_for_store_manager, only: %i[ show edit update destroy ]

  # GET /prefix_and_digits_for_store_managers or /prefix_and_digits_for_store_managers.json
  def index
    @prefix_and_digits_for_store_managers = PrefixAndDigitsForStoreManager.all
  end

  # GET /prefix_and_digits_for_store_managers/1 or /prefix_and_digits_for_store_managers/1.json
  def show
  end

  # GET /prefix_and_digits_for_store_managers/new
  def new
    @prefix_and_digits_for_store_manager = PrefixAndDigitsForStoreManager.new
  end

  # GET /prefix_and_digits_for_store_managers/1/edit
  def edit
  end

  # POST /prefix_and_digits_for_store_managers or /prefix_and_digits_for_store_managers.json
  def create
    @prefix_and_digits_for_store_manager = PrefixAndDigitsForStoreManager.new(prefix_and_digits_for_store_manager_params)

    respond_to do |format|
      if @prefix_and_digits_for_store_manager.save
        format.html { redirect_to prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager), notice: "Prefix and digits for store manager was successfully created." }
        format.json { render :show, status: :created, location: @prefix_and_digits_for_store_manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_store_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefix_and_digits_for_store_managers/1 or /prefix_and_digits_for_store_managers/1.json
  def update
    respond_to do |format|
      if @prefix_and_digits_for_store_manager.update(prefix_and_digits_for_store_manager_params)
        format.html { redirect_to prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager), notice: "Prefix and digits for store manager was successfully updated." }
        format.json { render :show, status: :ok, location: @prefix_and_digits_for_store_manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_store_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefix_and_digits_for_store_managers/1 or /prefix_and_digits_for_store_managers/1.json
  def destroy
    @prefix_and_digits_for_store_manager.destroy!

    respond_to do |format|
      format.html { redirect_to prefix_and_digits_for_store_managers_url, notice: "Prefix and digits for store manager was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefix_and_digits_for_store_manager
      @prefix_and_digits_for_store_manager = PrefixAndDigitsForStoreManager.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prefix_and_digits_for_store_manager_params
      params.require(:prefix_and_digits_for_store_manager).permit(:prefix, :minimum_digits)
    end
end
