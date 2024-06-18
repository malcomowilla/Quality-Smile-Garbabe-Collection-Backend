require "application_system_test_case"

class PrefixAndDigitsForServiceProvidersTest < ApplicationSystemTestCase
  setup do
    @prefix_and_digits_for_service_provider = prefix_and_digits_for_service_providers(:one)
  end

  test "visiting the index" do
    visit prefix_and_digits_for_service_providers_url
    assert_selector "h1", text: "Prefix and digits for service providers"
  end

  test "should create prefix and digits for service provider" do
    visit prefix_and_digits_for_service_providers_url
    click_on "New prefix and digits for service provider"

    fill_in "Minimum digits", with: @prefix_and_digits_for_service_provider.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_service_provider.prefix
    click_on "Create Prefix and digits for service provider"

    assert_text "Prefix and digits for service provider was successfully created"
    click_on "Back"
  end

  test "should update Prefix and digits for service provider" do
    visit prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
    click_on "Edit this prefix and digits for service provider", match: :first

    fill_in "Minimum digits", with: @prefix_and_digits_for_service_provider.minimum_digits
    fill_in "Prefix", with: @prefix_and_digits_for_service_provider.prefix
    click_on "Update Prefix and digits for service provider"

    assert_text "Prefix and digits for service provider was successfully updated"
    click_on "Back"
  end

  test "should destroy Prefix and digits for service provider" do
    visit prefix_and_digits_for_service_provider_url(@prefix_and_digits_for_service_provider)
    click_on "Destroy this prefix and digits for service provider", match: :first

    assert_text "Prefix and digits for service provider was successfully destroyed"
  end
end
