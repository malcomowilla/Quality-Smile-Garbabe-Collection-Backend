require "test_helper"

class SubLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_location = sub_locations(:one)
  end

  test "should get index" do
    get sub_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_location_url
    assert_response :success
  end

  test "should create sub_location" do
    assert_difference("SubLocation.count") do
      post sub_locations_url, params: { sub_location: { category: @sub_location.category, code: @sub_location.code, created_by: @sub_location.created_by, name: @sub_location.name } }
    end

    assert_redirected_to sub_location_url(SubLocation.last)
  end

  test "should show sub_location" do
    get sub_location_url(@sub_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_location_url(@sub_location)
    assert_response :success
  end

  test "should update sub_location" do
    patch sub_location_url(@sub_location), params: { sub_location: { category: @sub_location.category, code: @sub_location.code, created_by: @sub_location.created_by, name: @sub_location.name } }
    assert_redirected_to sub_location_url(@sub_location)
  end

  test "should destroy sub_location" do
    assert_difference("SubLocation.count", -1) do
      delete sub_location_url(@sub_location)
    end

    assert_redirected_to sub_locations_url
  end
end
