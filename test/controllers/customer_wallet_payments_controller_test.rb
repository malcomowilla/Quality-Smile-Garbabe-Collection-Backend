require "test_helper"

class CustomerWalletPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_wallet_payment = customer_wallet_payments(:one)
  end

  test "should get index" do
    get customer_wallet_payments_url, as: :json
    assert_response :success
  end

  test "should create customer_wallet_payment" do
    assert_difference("CustomerWalletPayment.count") do
      post customer_wallet_payments_url, params: { customer_wallet_payment: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show customer_wallet_payment" do
    get customer_wallet_payment_url(@customer_wallet_payment), as: :json
    assert_response :success
  end

  test "should update customer_wallet_payment" do
    patch customer_wallet_payment_url(@customer_wallet_payment), params: { customer_wallet_payment: {  } }, as: :json
    assert_response :success
  end

  test "should destroy customer_wallet_payment" do
    assert_difference("CustomerWalletPayment.count", -1) do
      delete customer_wallet_payment_url(@customer_wallet_payment), as: :json
    end

    assert_response :no_content
  end
end
