class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy ]
before_action :set_admin, only: %i[ create show edit update destroy ]


load_and_authorize_resource





  # GET /stores or /stores.json
  def index

    @stores = Store.all
    render json: @stores

    
  end



  def create
    @store = Store.new(store_params)
  
    if @store.save
      if @admin.respond_to?(:prefix_and_digits_for_stores)
        @prefix_and_digits = @admin.prefix_and_digits_for_stores.first
  
        if @prefix_and_digits.present?
          found_prefix = @prefix_and_digits.prefix
          found_digits = @prefix_and_digits.minimum_digits.to_i
          Rails.logger.info "Prefix and digit relationship found"
  
          auto_generated_number = "#{found_prefix}#{@store.sequence_number.to_s.rjust(found_digits, '0')}"
          @store.update(store_number: auto_generated_number)
  
          render json: @store, status: :created
        else
          Rails.logger.info "Prefix and digit relationship not found"
          render json: { error: "Prefix and digit not found for the account" }, status: :unprocessable_entity
        end
      else
        Rails.logger.info "Admin does not respond to prefix_and_digits_for_stores"
        render json: { error: "Admin does not have prefix and digits for stores" }, status: :unprocessable_entity
      end
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
