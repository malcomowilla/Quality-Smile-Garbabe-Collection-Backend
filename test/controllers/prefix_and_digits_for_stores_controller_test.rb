require "test_helper"

class PrefixAndDigitsForStoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix_and_digits_for_store = prefix_and_digits_for_stores(:one)
  end

  test "should get index" do
    get prefix_and_digits_for_stores_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_and_digits_for_store_url
    assert_response :success
  end

  test "should create prefix_and_digits_for_store" do
    assert_difference("PrefixAndDigitsForStore.count") do
      post prefix_and_digits_for_stores_url, params: { prefix_and_digits_for_store: { minimum_digits: @prefix_and_digits_for_store.minimum_digits, prefix: @prefix_and_digits_for_store.prefix } }
    end

    assert_redirected_to prefix_and_digits_for_store_url(PrefixAndDigitsForStore.last)
  end

  test "should show prefix_and_digits_for_store" do
    get prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
    assert_response :success
  end

  test "should update prefix_and_digits_for_store" do
    patch prefix_and_digits_for_store_url(@prefix_and_digits_for_store), params: { prefix_and_digits_for_store: { minimum_digits: @prefix_and_digits_for_store.minimum_digits, prefix: @prefix_and_digits_for_store.prefix } }
    assert_redirected_to prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
  end

  test "should destroy prefix_and_digits_for_store" do
    assert_difference("PrefixAndDigitsForStore.count", -1) do
      delete prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
    end

    assert_redirected_to prefix_and_digits_for_stores_url
  end
end
