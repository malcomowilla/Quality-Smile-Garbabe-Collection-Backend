require "test_helper"

class StoreManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @store_manager = store_managers(:one)
  end

  test "should get index" do
    get store_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_store_manager_url
    assert_response :success
  end

  test "should create store_manager" do
    assert_difference("StoreManager.count") do
      post store_managers_url, params: { store_manager: { date_delivered: @store_manager.date_delivered, date_reeived: @store_manager.date_reeived, number_of_bags_delivered: @store_manager.number_of_bags_delivered, number_of_bags_received: @store_manager.number_of_bags_received } }
    end

    assert_redirected_to store_manager_url(StoreManager.last)
  end

  test "should show store_manager" do
    get store_manager_url(@store_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_manager_url(@store_manager)
    assert_response :success
  end

  test "should update store_manager" do
    patch store_manager_url(@store_manager), params: { store_manager: { date_delivered: @store_manager.date_delivered, date_reeived: @store_manager.date_reeived, number_of_bags_delivered: @store_manager.number_of_bags_delivered, number_of_bags_received: @store_manager.number_of_bags_received } }
    assert_redirected_to store_manager_url(@store_manager)
  end

  test "should destroy store_manager" do
    assert_difference("StoreManager.count", -1) do
      delete store_manager_url(@store_manager)
    end

    assert_redirected_to store_managers_url
  end
end
