require "application_system_test_case"

class StoreManagersTest < ApplicationSystemTestCase
  setup do
    @store_manager = store_managers(:one)
  end

  test "visiting the index" do
    visit store_managers_url
    assert_selector "h1", text: "Store managers"
  end

  test "should create store manager" do
    visit store_managers_url
    click_on "New store manager"

    fill_in "Date delivered", with: @store_manager.date_delivered
    fill_in "Date reeived", with: @store_manager.date_reeived
    fill_in "Number of bags delivered", with: @store_manager.number_of_bags_delivered
    fill_in "Number of bags received", with: @store_manager.number_of_bags_received
    click_on "Create Store manager"

    assert_text "Store manager was successfully created"
    click_on "Back"
  end

  test "should update Store manager" do
    visit store_manager_url(@store_manager)
    click_on "Edit this store manager", match: :first

    fill_in "Date delivered", with: @store_manager.date_delivered
    fill_in "Date reeived", with: @store_manager.date_reeived
    fill_in "Number of bags delivered", with: @store_manager.number_of_bags_delivered
    fill_in "Number of bags received", with: @store_manager.number_of_bags_received
    click_on "Update Store manager"

    assert_text "Store manager was successfully updated"
    click_on "Back"
  end

  test "should destroy Store manager" do
    visit store_manager_url(@store_manager)
    click_on "Destroy this store manager", match: :first

    assert_text "Store manager was successfully destroyed"
  end
end
