require "application_system_test_case"

class PrefixAndDigitsForTicketNumbersTest < ApplicationSystemTestCase
  setup do
    @prefix_and_digits_for_ticket_number = prefix_and_digits_for_ticket_numbers(:one)
  end

  test "visiting the index" do
    visit prefix_and_digits_for_ticket_numbers_url
    assert_selector "h1", text: "Prefix and digits for ticket numbers"
  end

  test "should create prefix and digits for ticket number" do
    visit prefix_and_digits_for_ticket_numbers_url
    click_on "New prefix and digits for ticket number"

    fill_in "Minimum digits", with: @prefix_and_digits_for_ticket_number.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_ticket_number.prefix
    click_on "Create Prefix and digits for ticket number"

    assert_text "Prefix and digits for ticket number was successfully created"
    click_on "Back"
  end

  test "should update Prefix and digits for ticket number" do
    visit prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
    click_on "Edit this prefix and digits for ticket number", match: :first

    fill_in "Minimum digits", with: @prefix_and_digits_for_ticket_number.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_ticket_number.prefix
    click_on "Update Prefix and digits for ticket number"

    assert_text "Prefix and digits for ticket number was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix and digits for ticket number" do
    visit prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number)
    click_on "Destroy this prefix and digits for ticket number", match: :first

    assert_text "Prefix and digits for ticket number was successfully destroyed"
  end
end
