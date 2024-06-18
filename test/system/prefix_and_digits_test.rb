require "application_system_test_case"

class PrefixAndDigitsTest < ApplicationSystemTestCase
  setup do
    @prefix_and_digit = prefix_and_digits(:one)
  end

  test "visiting the index" do
    visit prefix_and_digits_url
    assert_selector "h1", text: "Prefix and digits"
  end

  test "should create prefix and digit" do
    visit prefix_and_digits_url
    click_on "New prefix and digit"

    fill_in "Minimum digits", with: @prefix_and_digit.minimum_digits
    fill_in "Prefix", with: @prefix_and_digit.prefix
    click_on "Create Prefix and digit"

    assert_text "Prefix and digit was successfully created"
    click_on "Back"
  end

  test "should update Prefix and digit" do
    visit prefix_and_digit_url(@prefix_and_digit)
    click_on "Edit this prefix and digit", match: :first

    fill_in "Minimum digits", with: @prefix_and_digit.minimum_digits
    fill_in "Prefix", with: @prefix_and_digit.prefix
    click_on "Update Prefix and digit"

    assert_text "Prefix and digit was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix and digit" do
    visit prefix_and_digit_url(@prefix_and_digit)
    click_on "Destroy this prefix and digit", match: :first

    assert_text "Prefix and digit was successfully destroyed"
  end
end
