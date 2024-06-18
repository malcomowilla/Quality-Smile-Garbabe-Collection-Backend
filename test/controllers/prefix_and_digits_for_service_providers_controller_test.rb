require "test_helper"

class PrefixAndDigitsForServiceProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix_and_digits_for_service_provider = prefix_and_digits_for_service_providers(:one)
  end

  test "should get index" do
    get prefix_and_digits_for_service_providers_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_and_digits_for_service_provider_url
    assert_response :success
  end

  test "should create prefix_and_digits_for_service_provider" do
    assert_difference("PrefixAndDigitsForServiceProvider.count") do
      post prefix_and_digits_for_service_providers_url, params: { prefix_and_digits_for_service_provider: { minimum_digits: @prefix_and_digits_for_service_provider.minimum_digits, prefix: @prefix_and_digits_for_service_provider.prefix } }
    end

    assert_redirected_to prefix_and_digits_for_service_provider_url(PrefixAndDigitsForServiceProvider.last)
  end

  test "should show prefix_and_digits_for_service_provider" do
    get prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
    assert_response :success
  end

  test "should update prefix_and_digits_for_service_provider" do
    patch prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider), params: { prefix_and_digits_for_service_provider: { minimum_digits: @prefix_and_digits_for_service_provider.minimum_digits, prefix: @prefix_and_digits_for_service_provider.prefix } }
    assert_redirected_to prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
  end

  test "should destroy prefix_and_digits_for_service_provider" do
    assert_difference("PrefixAndDigitsForServiceProvider.count", -1) do
      delete prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
    end

    assert_redirected_to prefix_and_digits_for_service_providers_url
  end
end
