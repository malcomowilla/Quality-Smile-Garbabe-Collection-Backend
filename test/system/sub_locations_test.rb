require "application_system_test_case"

class SubLocationsTest < ApplicationSystemTestCase
  setup do
    @sub_location = sub_locations(:one)
  end

  test "visiting the index" do
    visit sub_locations_url
    assert_selector "h1", text: "Sub locations"
  end

  test "should create sub location" do
    visit sub_locations_url
    click_on "New sub location"

    fill_in "Category", with: @sub_location.category
    fill_in "Code", with: @sub_location.code
    fill_in "Created by", with: @sub_location.created_by
    fill_in "Name", with: @sub_location.name
    click_on "Create Sub location"

    assert_text "Sub location was successfully created"
    click_on "Back"
  end

  test "should update Sub location" do
    visit sub_location_url(@sub_location)
    click_on "Edit this sub location", match: :first

    fill_in "Category", with: @sub_location.category
    fill_in "Code", with: @sub_location.code
    fill_in "Created by", with: @sub_location.created_by
    fill_in "Name", with: @sub_location.name
    click_on "Update Sub location"

    assert_text "Sub location was successfully updated"
    click_on "Back"
  end

  test "should destroy Sub location" do
    visit sub_location_url(@sub_location)
    click_on "Destroy this sub location", match: :first

    assert_text "Sub location was successfully destroyed"
  end
end
