require "test_helper"

class FinancesAndAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @finances_and_account = finances_and_accounts(:one)
  end

  test "should get index" do
    get finances_and_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_finances_and_account_url
    assert_response :success
  end

  test "should create finances_and_account" do
    assert_difference("FinancesAndAccount.count") do
      post finances_and_accounts_url, params: { finances_and_account: { category: @finances_and_account.category, date: @finances_and_account.date, description: @finances_and_account.description, name: @finances_and_account.name, reference: @finances_and_account.reference } }
    end

    assert_redirected_to finances_and_account_url(FinancesAndAccount.last)
  end

  test "should show finances_and_account" do
    get finances_and_account_url(@finances_and_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_finances_and_account_url(@finances_and_account)
    assert_response :success
  end

  test "should update finances_and_account" do
    patch finances_and_account_url(@finances_and_account), params: { finances_and_account: { category: @finances_and_account.category, date: @finances_and_account.date, description: @finances_and_account.description, name: @finances_and_account.name, reference: @finances_and_account.reference } }
    assert_redirected_to finances_and_account_url(@finances_and_account)
  end

  test "should destroy finances_and_account" do
    assert_difference("FinancesAndAccount.count", -1) do
      delete finances_and_account_url(@finances_and_account)
    end

    assert_redirected_to finances_and_accounts_url
  end
end
