require "test_helper"

class PrefixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix = prefixes(:one)
  end

  test "should get index" do
    get prefixes_url
    assert_response :success
  end

  test "should get new" do
    get new_prefix_url
    assert_response :success
  end

  test "should create prefix" do
    assert_difference("Prefix.count") do
      post prefixes_url, params: { prefix: { minimum_digits: @prefix.minimum_digits } }
    end

    assert_redirected_to prefix_url(Prefix.last)
  end

  test "should show prefix" do
    get prefix_url(@prefix)
    assert_response :success
  end

  test "should get edit" do
    get edit_prefix_url(@prefix)
    assert_response :success
  end

  test "should update prefix" do
    patch prefix_url(@prefix), params: { prefix: { minimum_digits: @prefix.minimum_digits } }
    assert_redirected_to prefix_url(@prefix)
  end

  test "should destroy prefix" do
    assert_difference("Prefix.count", -1) do
      delete prefix_url(@prefix)
    end

    assert_redirected_to prefixes_url
  end
end
