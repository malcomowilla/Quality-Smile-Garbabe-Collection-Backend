require "test_helper"

class PrefixAndDigitsForTicketNumbersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix_and_digits_for_ticket_number = prefix_and_digits_for_ticket_numbers(:one)
  end

  test "should get index" do
    get prefix_and_digits_for_ticket_numbers_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_and_digits_for_ticket_number_url
    assert_response :success
  end

  test "should create prefix_and_digits_for_ticket_number" do
    assert_difference("PrefixAndDigitsForTicketNumber.count") do
      post prefix_and_digits_for_ticket_numbers_url, params: { prefix_and_digits_for_ticket_number: { minimum_digits: @prefix_and_digits_for_ticket_number.minimum_digits, prefix: @prefix_and_digits_for_ticket_number.prefix } }
    end

    assert_redirected_to prefix_and_digits_for_ticket_number_url(PrefixAndDigitsForTicketNumber.last)
  end

  test "should show prefix_and_digits_for_ticket_number" do
    get prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
    assert_response :success
  end

  test "should update prefix_and_digits_for_ticket_number" do
    patch prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number), params: { prefix_and_digits_for_ticket_number: { minimum_digits: @prefix_and_digits_for_ticket_number.minimum_digits, prefix: @prefix_and_digits_for_ticket_number.prefix } }
    assert_redirected_to prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
  end

  test "should destroy prefix_and_digits_for_ticket_number" do
    assert_difference("PrefixAndDigitsForTicketNumber.count", -1) do
      delete prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
    end

    assert_redirected_to prefix_and_digits_for_ticket_numbers_url
  end
end
