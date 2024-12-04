module Api
  class PaymentsController < ApplicationController
    before_action :authenticate_admin!
    
    def create
      @subscription = current_admin.account.subscription
      
      payment = @subscription.payments.new(
        amount_cents: 1000000, # 10,000 KES
        currency: 'KES',
        payment_method: params[:payment_method],
        mpesa_phone_number: params[:phone_number],
        status: 'pending'
      )

      if payment.save
        if payment.payment_method == 'mpesa'
          # Initiate M-Pesa STK Push
          result = MpesaService.stk_push(
            phone_number: payment.mpesa_phone_number,
            amount: payment.amount,
            reference: "SUB-#{@subscription.id}",
            description: "Aitechs Subscription Renewal"
          )

          if result[:success]
            render json: {
              message: 'Please check your phone to complete the payment',
              checkout_request_id: result[:checkout_request_id]
            }
          else
            payment.update(status: 'failed')
            render json: { error: 'Failed to initiate payment' }, status: :unprocessable_entity
          end
        else
          # Handle card payment (implement card payment gateway integration)
          render json: { redirect_url: '/card-payment' }
        end
      else
        render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def mpesa_callback
      # Handle M-Pesa callback
      payment = Payment.find_by(transaction_reference: params[:CheckoutRequestID])
      
      if payment && params[:ResultCode] == '0'
        payment.update(
          status: 'completed',
          mpesa_receipt_number: params[:MpesaReceiptNumber],
          payment_details: params
        )
        
        payment.subscription.renew!
        
        # Notify admin of successful payment
        AdminMailer.payment_successful(payment).deliver_later
      else
        payment&.update(
          status: 'failed',
          payment_details: params
        )
      end

      head :ok
    end

    def payment_status
      payment = Payment.find(params[:id])
      render json: {
        status: payment.status,
        message: payment_status_message(payment)
      }
    end

    private

    def payment_status_message(payment)
      case payment.status
      when 'completed'
        'Payment completed successfully'
      when 'pending'
        'Waiting for payment confirmation'
      when 'failed'
        'Payment failed. Please try again'
      else
        'Unknown payment status'
      end
    end
  end
end
