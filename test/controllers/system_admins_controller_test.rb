require "test_helper"

class SystemAdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_admin = system_admins(:one)
  end

  test "should get index" do
    get system_admins_url, as: :json
    assert_response :success
  end

  test "should create system_admin" do
    assert_difference("SystemAdmin.count") do
      post system_admins_url, params: { system_admin: { email: @system_admin.email, password_digest: @system_admin.password_digest, user_name: @system_admin.user_name } }, as: :json
    end

    assert_response :created
  end

  test "should show system_admin" do
    get system_admin_url(@system_admin), as: :json
    assert_response :success
  end

  test "should update system_admin" do
    patch system_admin_url(@system_admin), params: { system_admin: { email: @system_admin.email, password_digest: @system_admin.password_digest, user_name: @system_admin.user_name } }, as: :json
    assert_response :success
  end

  test "should destroy system_admin" do
    assert_difference("SystemAdmin.count", -1) do
      delete system_admin_url(@system_admin), as: :json
    end

    assert_response :no_content
  end
end
