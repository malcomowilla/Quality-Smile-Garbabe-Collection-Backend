class CustomerWalletPaymentsController < ApplicationController
  before_action :set_customer_wallet_payment, only: %i[ show update destroy ]

  # GET /customer_wallet_payments
  # GET /customer_wallet_payments.json
  def index
    @customer_wallet_payments = CustomerWalletPayment.all
  end

  # GET /customer_wallet_payments/1
  # GET /customer_wallet_payments/1.json
  def show
  end

  # POST /customer_wallet_payments
  # POST /customer_wallet_payments.json
  def create
    @customer_wallet_payment = CustomerWalletPayment.new(customer_wallet_payment_params)

    if @customer_wallet_payment.save
      render :show, status: :created, location: @customer_wallet_payment
    else
      render json: @customer_wallet_payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_wallet_payments/1
  # PATCH/PUT /customer_wallet_payments/1.json
  def update
    if @customer_wallet_payment.update(customer_wallet_payment_params)
      render :show, status: :ok, location: @customer_wallet_payment
    else
      render json: @customer_wallet_payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_wallet_payments/1
  # DELETE /customer_wallet_payments/1.json
  def destroy
    @customer_wallet_payment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_wallet_payment
      @customer_wallet_payment = CustomerWalletPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_wallet_payment_params
      params.fetch(:customer_wallet_payment, {})
    end
end
