require "test_helper"

class PrefixAndDigitsForStoreManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix_and_digits_for_store_manager = prefix_and_digits_for_store_managers(:one)
  end

  test "should get index" do
    get prefix_and_digits_for_store_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_and_digits_for_store_manager_url
    assert_response :success
  end

  test "should create prefix_and_digits_for_store_manager" do
    assert_difference("PrefixAndDigitsForStoreManager.count") do
      post prefix_and_digits_for_store_managers_url, params: { prefix_and_digits_for_store_manager: { minimum_digits: @prefix_and_digits_for_store_manager.minimum_digits, prefix: @prefix_and_digits_for_store_manager.prefix } }
    end

    assert_redirected_to prefix_and_digits_for_store_manager_url(PrefixAndDigitsForStoreManager.last)
  end

  test "should show prefix_and_digits_for_store_manager" do
    get prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
    assert_response :success
  end

  test "should update prefix_and_digits_for_store_manager" do
    patch prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager), params: { prefix_and_digits_for_store_manager: { minimum_digits: @prefix_and_digits_for_store_manager.minimum_digits, prefix: @prefix_and_digits_for_store_manager.prefix } }
    assert_redirected_to prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
  end

  test "should destroy prefix_and_digits_for_store_manager" do
    assert_difference("PrefixAndDigitsForStoreManager.count", -1) do
      delete prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
    end

    assert_redirected_to prefix_and_digits_for_store_managers_url
  end
end
