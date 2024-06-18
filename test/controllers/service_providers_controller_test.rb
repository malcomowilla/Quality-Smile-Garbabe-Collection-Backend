require "test_helper"

class ServiceProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_provider = service_providers(:one)
  end

  test "should get index" do
    get service_providers_url
    assert_response :success
  end

  test "should get new" do
    get new_service_provider_url
    assert_response :success
  end

  test "should create service_provider" do
    assert_difference("ServiceProvider.count") do
      post service_providers_url, params: { service_provider: { email: @service_provider.email, name: @service_provider.name, phone_number: @service_provider.phone_number, provider_code: @service_provider.provider_code, status: @service_provider.status } }
    end

    assert_redirected_to service_provider_url(ServiceProvider.last)
  end

  test "should show service_provider" do
    get service_provider_url(@service_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_provider_url(@service_provider)
    assert_response :success
  end

  test "should update service_provider" do
    patch service_provider_url(@service_provider), params: { service_provider: { email: @service_provider.email, name: @service_provider.name, phone_number: @service_provider.phone_number, provider_code: @service_provider.provider_code, status: @service_provider.status } }
    assert_redirected_to service_provider_url(@service_provider)
  end

  test "should destroy service_provider" do
    assert_difference("ServiceProvider.count", -1) do
      delete service_provider_url(@service_provider)
    end

    assert_redirected_to service_providers_url
  end
end
