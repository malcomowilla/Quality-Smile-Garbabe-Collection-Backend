class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]
require "uri"
require "net/http"
  # GET /payments or /payments.json
  def index
    @payments = Payment.all
  end

  def make_mpesa_payment 
    

url = URI("https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/json"
request["Authorization"] = "Bearer 3CsqgFK2021WQytRAS9xIU6tWFwG"

request.body = {
    "ShortCode": 600982,
    "CommandID": "CustomerBuyGoodsOnline",
    "amount": "1",
    "MSISDN": "254705912645",
    "BillRefNumber": "",
  }

response = https.request(request)
puts response.read_body
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully updated." }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy!

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount)
    end
end
