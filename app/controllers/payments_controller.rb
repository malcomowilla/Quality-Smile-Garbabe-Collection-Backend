class PaymentsController < ApplicationController

  require "uri"
  require "net/http"
  require "json"
  require "base64"


  load_and_authorize_resource

  # GET /payments or /payments.json
  def index
    @payments = Payment.all
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

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def payment_params
    params.require(:payment).permit(:payment_code, :phone_number, :name, :amount_paid, :total, :remaining_amount)
  end
end
