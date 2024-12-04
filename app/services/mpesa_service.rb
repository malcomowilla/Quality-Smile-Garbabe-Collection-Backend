class MpesaService
  class << self
    def stk_push(phone_number:, amount:, reference:, description:)
      timestamp = Time.current.strftime('%Y%m%d%H%M%S')
      password = generate_password(timestamp)

      payload = {
        BusinessShortCode: ENV['MPESA_SHORTCODE'],
        Password: password,
        Timestamp: timestamp,
        TransactionType: "CustomerPayBillOnline",
        Amount: amount.to_i,
        PartyA: phone_number,
        PartyB: ENV['MPESA_SHORTCODE'],
        PhoneNumber: phone_number,
        CallBackURL: ENV['MPESA_CALLBACK_URL'],
        AccountReference: reference,
        TransactionDesc: description
      }

      response = make_request(
        endpoint: "mpesa/stkpush/v1/processrequest",
        payload: payload
      )

      if response["ResponseCode"] == "0"
        {
          success: true,
          checkout_request_id: response["CheckoutRequestID"]
        }
      else
        {
          success: false,
          error: response["ResponseDescription"]
        }
      end
    rescue => e
      Rails.logger.error "M-Pesa STK Push Error: #{e.message}"
      { success: false, error: "Payment initiation failed" }
    end

    private

    def generate_password(timestamp)
      key = ENV['MPESA_SHORTCODE'] + ENV['MPESA_PASSKEY'] + timestamp
      Base64.strict_encode64(key)
    end

    def make_request(endpoint:, payload:)
      url = "https://sandbox.safaricom.co.ke/#{endpoint}"
      
      response = HTTP.auth("Bearer #{get_access_token}")
                    .post(url, json: payload)

      JSON.parse(response.body.to_s)
    end

    def get_access_token
      url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
      
      auth = Base64.strict_encode64(
        "#{ENV['MPESA_CONSUMER_KEY']}:#{ENV['MPESA_CONSUMER_SECRET']}"
      )

      response = HTTP.auth("Basic #{auth}")
                    .get(url)

      JSON.parse(response.body.to_s)["access_token"]
    end
  end
end
