class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
  end


  # POST /customers or /customers.json
  def create
    @customer = Customer.create(customer_params)

      if @customer.save
     
        render json: {message: 'customer succesfully created', customer: @customer}, status: :created
      else
        render json: {error: 'cannot create customer'}, status: :unprocessable_entity
       
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    customer = set_customer
      if @customer
        customer.update(customer_params)
       render json: {message: 'customer successfully updated', customer: customer}
      else
        render json: {error: 'cannot update customer'}, status: :unprocessable_entity

      end
  
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer = set_customer
    @customer.destroy!

   head :no_content
  end
a7pdwf
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:name, :email, :phone_number, :location, :customer_code)
    end
end
