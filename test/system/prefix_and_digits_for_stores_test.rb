require "application_system_test_case"

class PrefixAndDigitsForStoresTest < ApplicationSystemTestCase
  setup do
    @prefix_and_digits_for_store = prefix_and_digits_for_stores(:one)
  end

  test "visiting the index" do
    visit prefix_and_digits_for_stores_url
    assert_selector "h1", text: "Prefix and digits for stores"
  end

  test "should create prefix and digits for store" do
    visit prefix_and_digits_for_stores_url
    click_on "New prefix and digits for store"

    fill_in "Minimum digits", with: @prefix_and_digits_for_store.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_store.prefix
    click_on "Create Prefix and digits for store"

    assert_text "Prefix and digits for store was successfully created"
    click_on "Back"
  end

  test "should update Prefix and digits for store" do
    visit prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
    click_on "Edit this prefix and digits for store", match: :first

    fill_in "Minimum digits", with: @prefix_and_digits_for_store.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_store.prefix
    click_on "Update Prefix and digits for store"

    assert_text "Prefix and digits for store was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix and digits for store" do
    visit prefix_and_digits_for_store_url(@prefix_and_digits_for_store)
    click_on "Destroy this prefix and digits for store", match: :first

    assert_text "Prefix and digits for store was successfully destroyed"
  end
end
