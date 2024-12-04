require "test_helper"

class CustomerPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_payment = customer_payments(:one)
  end

  test "should get index" do
    get customer_payments_url, as: :json
    assert_response :success
  end

  test "should create customer_payment" do
    assert_difference("CustomerPayment.count") do
      post customer_payments_url, params: { customer_payment: { account_id: @customer_payment.account_id, amount_paid: @customer_payment.amount_paid, currency: @customer_payment.currency, name: @customer_payment.name, payment_code: @customer_payment.payment_code, phone_number: @customer_payment.phone_number, remaining_amount: @customer_payment.remaining_amount, status: @customer_payment.status, total: @customer_payment.total } }, as: :json
    end

    assert_response :created
  end

  test "should show customer_payment" do
    get customer_payment_url(@customer_payment), as: :json
    assert_response :success
  end

  test "should update customer_payment" do
    patch customer_payment_url(@customer_payment), params: { customer_payment: { account_id: @customer_payment.account_id, amount_paid: @customer_payment.amount_paid, currency: @customer_payment.currency, name: @customer_payment.name, payment_code: @customer_payment.payment_code, phone_number: @customer_payment.phone_number, remaining_amount: @customer_payment.remaining_amount, status: @customer_payment.status, total: @customer_payment.total } }, as: :json
    assert_response :success
  end

  test "should destroy customer_payment" do
    assert_difference("CustomerPayment.count", -1) do
      delete customer_payment_url(@customer_payment), as: :json
    end

    assert_response :no_content
  end
end
