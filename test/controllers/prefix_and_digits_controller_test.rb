require "test_helper"

class PrefixAndDigitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix_and_digit = prefix_and_digits(:one)
  end

  test "should get index" do
    get prefix_and_digits_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_and_digit_url
    assert_response :success
  end

  test "should create prefix_and_digit" do
    assert_difference("PrefixAndDigit.count") do
      post prefix_and_digits_url, params: { prefix_and_digit: { minimum_digits: @prefix_and_digit.minimum_digits, prefix: @prefix_and_digit.prefix } }
    end

    assert_redirected_to prefix_and_digit_url(PrefixAndDigit.last)
  end

  test "should show prefix_and_digit" do
    get prefix_and_digit_url(@prefix_and_digit)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_and_digit_url(@prefix_and_digit)
    assert_response :success
  end

  test "should update prefix_and_digit" do
    patch prefix_and_digit_url(@prefix_and_digit), params: { prefix_and_digit: { minimum_digits: @prefix_and_digit.minimum_digits, prefix: @prefix_and_digit.prefix } }
    assert_redirected_to prefix_and_digit_url(@prefix_and_digit)
  end

  test "should destroy prefix_and_digit" do
    assert_difference("PrefixAndDigit.count", -1) do
      delete prefix_and_digit_url(@prefix_and_digit)
    end

    assert_redirected_to prefix_and_digits_url
  end
end
