require "application_system_test_case"

class FinancesAndAccountsTest < ApplicationSystemTestCase
  setup do
    @finances_and_account = finances_and_accounts(:one)
  end

  test "visiting the index" do
    visit finances_and_accounts_url
    assert_selector "h1", text: "Finances and accounts"
  end

  test "should create finances and account" do
    visit finances_and_accounts_url
    click_on "New finances and account"

    fill_in "Category", with: @finances_and_account.category
    fill_in "Date", with: @finances_and_account.date
    fill_in "Description", with: @finances_and_account.description
    fill_in "Name", with: @finances_and_account.name
    fill_in "Reference", with: @finances_and_account.reference
    click_on "Create Finances and account"

    assert_text "Finances and account was successfully created"
    click_on "Back"
  end

  test "should update Finances and account" do
    visit finances_and_account_url(@finances_and_account)
    click_on "Edit this finances and account", match: :first

    fill_in "Category", with: @finances_and_account.category
    fill_in "Date", with: @finances_and_account.date
    fill_in "Description", with: @finances_and_account.description
    fill_in "Name", with: @finances_and_account.name
    fill_in "Reference", with: @finances_and_account.reference
    click_on "Update Finances and account"

    assert_text "Finances and account was successfully updated"
    click_on "Back"
  end

  test "should destroy Finances and account" do
    visit finances_and_account_url(@finances_and_account)
    click_on "Destroy this finances and account", match: :first

    assert_text "Finances and account was successfully destroyed"
  end
end
