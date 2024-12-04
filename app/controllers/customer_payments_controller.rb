class CustomerPaymentsController < ApplicationController
  before_action :set_customer_payment, only: %i[ show update destroy ]

  # GET /customer_payments
  # GET /customer_payments.json
  def index
    @customer_payments = CustomerPayment.all
  end




  def make_mpesa_payment
    url = URI("https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{get_access_token}"

    request.body = {
      "ShortCode": '',
      "ValidationURL": 'https://quality-smile-garbabe-collection-backend-1jcd.onrender.com/validate',
      "ConfirmationURL": 'https://quality-smile-garbabe-collection-backend-1jcd.onrender.com/confirm',
      "ResponseType": "Completed"
    }.to_json

    response = Net::HTTP.start(url.hostname, url.port) do |http|
      https.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      render json: { message: "Registered URL successfully", response: response.body }
    else
      puts "Failed to register URL2: #{response.code} - #{response.message}"
      render json: { error: "Failed to register URL: #{response.code} - #{response.message}" }, status: :unprocessable_entity
    end
  end

  def validate
    Rails.logger.info "Validating payment: #{request.body.read}"
    render json: { message: "Validating payment: #{request.body.read}" }
  end

  def confirm
    Rails.logger.info "Transaction confirmation received: #{request.body.read}"
    render json: { message: "Transaction confirmation received: #{request.body.read}" }
  end

  private

  def get_access_token
    consumer_key = 'SWDOWGEOKiIGze0vKFccwv9PQcO337UuGAnAAdVPH3J0QOzh'
    consumer_secret = 'crjxwBMtgE6dJk8rtrnYUfFZSsGS3T1jJQy5yn5P2AlqWgWL7l5S7soJjATxNte2'
    uri = URI("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")}"

    response = https.request(request)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data['access_token']
    else
      raise "Failed to get access token: #{response.code} - #{response.message}"
    end
  end






  # POST /customer_payments
  # POST /customer_payments.json
  def create
    @customer_payment = CustomerPayment.new(customer_payment_params)

    if @customer_payment.save
      render :show, status: :created, location: @customer_payment
    else
      render json: @customer_payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customer_payments/1
  # PATCH/PUT /customer_payments/1.json
  def update
    if @customer_payment.update(customer_payment_params)
      render :show, status: :ok, location: @customer_payment
    else
      render json: @customer_payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customer_payments/1
  # DELETE /customer_payments/1.json
  def destroy
    @customer_payment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_payment
      @customer_payment = CustomerPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_payment_params
      params.require(:customer_payment).permit(:payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount, :status, :account_id, :currency)
    end
end
