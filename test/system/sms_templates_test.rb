require "application_system_test_case"

class SmsTemplatesTest < ApplicationSystemTestCase
  setup do
    @sms_template = sms_templates(:one)
  end

  test "visiting the index" do
    visit sms_templates_url
    assert_selector "h1", text: "Sms templates"
  end

  test "should create sms template" do
    visit sms_templates_url
    click_on "New sms template"

    fill_in "Admin otp confirmation template", with: @sms_template.admin_otp_confirmation_template
    fill_in "Customer confirmation code template", with: @sms_template.customer_confirmation_code_template
    fill_in "Customer otp confirmation template", with: @sms_template.customer_otp_confirmation_template
    fill_in "Payment reminder template", with: @sms_template.payment_reminder_template
    fill_in "Service provider confirmation code template", with: @sms_template.service_provider_confirmation_code_template
    fill_in "Service provider otp confirmation template", with: @sms_template.service_provider_otp_confirmation_template
    fill_in "User invitation template", with: @sms_template.user_invitation_template
    click_on "Create Sms template"

    assert_text "Sms template was successfully created"
    click_on "Back"
  end

  test "should update Sms template" do
    visit sms_template_url(@sms_template)
    click_on "Edit this sms template", match: :first

    fill_in "Admin otp confirmation template", with: @sms_template.admin_otp_confirmation_template
    fill_in "Customer confirmation code template", with: @sms_template.customer_confirmation_code_template
    fill_in "Customer otp confirmation template", with: @sms_template.customer_otp_confirmation_template
    fill_in "Payment reminder template", with: @sms_template.payment_reminder_template
    fill_in "Service provider confirmation code template", with: @sms_template.service_provider_confirmation_code_template
    fill_in "Service provider otp confirmation template", with: @sms_template.service_provider_otp_confirmation_template
    fill_in "User invitation template", with: @sms_template.user_invitation_template
    click_on "Update Sms template"

    assert_text "Sms template was successfully updated"
    click_on "Back"
  end

  test "should destroy Sms template" do
    visit sms_template_url(@sms_template)
    click_on "Destroy this sms template", match: :first

    assert_text "Sms template was successfully destroyed"
  end
end
