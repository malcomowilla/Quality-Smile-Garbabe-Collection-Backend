require "application_system_test_case"

class PrefixesTest < ApplicationSystemTestCase
  setup do
    @prefix = prefixes(:one)
  end

  test "visiting the index" do
    visit prefixes_url
    assert_selector "h1", text: "Prefixes"
  end

  test "should create prefix" do
    visit prefixes_url
    click_on "New prefix"

    fill_in "Minimum digits", with: @prefix.minimum_digits
    click_on "Create Prefix"

    assert_text "Prefix was successfully created"
    click_on "Back"
  end

  test "should update Prefix" do
    visit prefix_url(@prefix)
    click_on "Edit this prefix", match: :first

    fill_in "Minimum digits", with: @prefix.minimum_digits
    click_on "Update Prefix"

    assert_text "Prefix was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix" do
    visit prefix_url(@prefix)
    click_on "Destroy this prefix", match: :first

    assert_text "Prefix was successfully destroyed"
  end
end
