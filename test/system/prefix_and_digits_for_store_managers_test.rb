require "application_system_test_case"

class PrefixAndDigitsForStoreManagersTest < ApplicationSystemTestCase
  setup do
    @prefix_and_digits_for_store_manager = prefix_and_digits_for_store_managers(:one)
  end

  test "visiting the index" do
    visit prefix_and_digits_for_store_managers_url
    assert_selector "h1", text: "Prefix and digits for store managers"
  end

  test "should create prefix and digits for store manager" do
    visit prefix_and_digits_for_store_managers_url
    click_on "New prefix and digits for store manager"

    fill_in "Minimum digits", with: @prefix_and_digits_for_store_manager.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_store_manager.prefix
    click_on "Create Prefix and digits for store manager"

    assert_text "Prefix and digits for store manager was successfully created"
    click_on "Back"
  end

  test "should update Prefix and digits for store manager" do
    visit prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
    click_on "Edit this prefix and digits for store manager", match: :first

    fill_in "Minimum digits", with: @prefix_and_digits_for_store_manager.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_store_manager.prefix
    click_on "Update Prefix and digits for store manager"

    assert_text "Prefix and digits for store manager was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix and digits for store manager" do
    visit prefix_and_digits_for_store_manager_url(@prefix_and_digits_for_store_manager)
    click_on "Destroy this prefix and digits for store manager", match: :first

    assert_text "Prefix and digits for store manager was successfully destroyed"
  end
end
