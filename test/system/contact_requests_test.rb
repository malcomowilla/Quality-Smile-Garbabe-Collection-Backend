require "application_system_test_case"

class ContactRequestsTest < ApplicationSystemTestCase
  setup do
    @contact_request = contact_requests(:one)
  end

  test "visiting the index" do
    visit contact_requests_url
    assert_selector "h1", text: "Contact requests"
  end

  test "should create contact request" do
    visit contact_requests_url
    click_on "New contact request"

    fill_in "Business email", with: @contact_request.business_email
    fill_in "Business type", with: @contact_request.business_type
    fill_in "Company name", with: @contact_request.company_name
    fill_in "Contact person", with: @contact_request.contact_person
    fill_in "Expected users", with: @contact_request.expected_users
    fill_in "Phone number", with: @contact_request.phone_number
    click_on "Create Contact request"

    assert_text "Contact request was successfully created"
    click_on "Back"
  end

  test "should update Contact request" do
    visit contact_request_url(@contact_request)
    click_on "Edit this contact request", match: :first

    fill_in "Business email", with: @contact_request.business_email
    fill_in "Business type", with: @contact_request.business_type
    fill_in "Company name", with: @contact_request.company_name
    fill_in "Contact person", with: @contact_request.contact_person
    fill_in "Expected users", with: @contact_request.expected_users
    fill_in "Phone number", with: @contact_request.phone_number
    click_on "Update Contact request"

    assert_text "Contact request was successfully updated"
    click_on "Back"
  end

  test "should destroy Contact request" do
    visit contact_request_url(@contact_request)
    click_on "Destroy this contact request", match: :first

    assert_text "Contact request was successfully destroyed"
  end
end
