class PrefixAndDigitsForStoresController < ApplicationController
  before_action :set_prefix_and_digits_for_store, only: %i[ show edit update destroy ]

  # GET /prefix_and_digits_for_stores or /prefix_and_digits_for_stores.json
  def index
    @prefix_and_digits_for_stores = PrefixAndDigitsForStore.all
  end

  # GET /prefix_and_digits_for_stores/1 or /prefix_and_digits_for_stores/1.json
  def show
  end

  # GET /prefix_and_digits_for_stores/new
  def new
    @prefix_and_digits_for_store = PrefixAndDigitsForStore.new
  end

  # GET /prefix_and_digits_for_stores/1/edit
  def edit
  end

  # POST /prefix_and_digits_for_stores or /prefix_and_digits_for_stores.json
  def create
    @prefix_and_digits_for_store = PrefixAndDigitsForStore.new(prefix_and_digits_for_store_params)

    respond_to do |format|
      if @prefix_and_digits_for_store.save
        format.html { redirect_to prefix_and_digits_for_store_url(@prefix_and_digits_for_store), notice: "Prefix and digits for store was successfully created." }
        format.json { render :show, status: :created, location: @prefix_and_digits_for_store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefix_and_digits_for_stores/1 or /prefix_and_digits_for_stores/1.json
  def update
    respond_to do |format|
      if @prefix_and_digits_for_store.update(prefix_and_digits_for_store_params)
        format.html { redirect_to prefix_and_digits_for_store_url(@prefix_and_digits_for_store), notice: "Prefix and digits for store was successfully updated." }
        format.json { render :show, status: :ok, location: @prefix_and_digits_for_store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefix_and_digits_for_stores/1 or /prefix_and_digits_for_stores/1.json
  def destroy
    @prefix_and_digits_for_store.destroy!

    respond_to do |format|
      format.html { redirect_to prefix_and_digits_for_stores_url, notice: "Prefix and digits for store was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefix_and_digits_for_store
      @prefix_and_digits_for_store = PrefixAndDigitsForStore.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prefix_and_digits_for_store_params
      params.require(:prefix_and_digits_for_store).permit(:prefix, :minimum_digits)
    end
end
