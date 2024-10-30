require "application_system_test_case"

class EmailTemplatesTest < ApplicationSystemTestCase
  setup do
    @email_template = email_templates(:one)
  end

  test "visiting the index" do
    visit email_templates_url
    assert_selector "h1", text: "Email templates"
  end

  test "should create email template" do
    visit email_templates_url
    click_on "New email template"

    fill_in "Admin otp confirmation body", with: @email_template.admin_otp_confirmation_body
    fill_in "Admin otp confirmation footer", with: @email_template.admin_otp_confirmation_footer
    fill_in "Admin otp confirmation header", with: @email_template.admin_otp_confirmation_header
    fill_in "Customer confirmation code body", with: @email_template.customer_confirmation_code_body
    fill_in "Customer confirmation code footer", with: @email_template.customer_confirmation_code_footer
    fill_in "Customer confirmation code header", with: @email_template.customer_confirmation_code_header
    fill_in "Customer otp confirmation body", with: @email_template.customer_otp_confirmation_body
    fill_in "Customer otp confirmation footer", with: @email_template.customer_otp_confirmation_footer
    fill_in "Customer otp confirmation header", with: @email_template.customer_otp_confirmation_header
    fill_in "Payment reminder body", with: @email_template.payment_reminder_body
    fill_in "Payment reminder footer", with: @email_template.payment_reminder_footer
    fill_in "Payment reminder header", with: @email_template.payment_reminder_header
    fill_in "Service provider confirmation code body", with: @email_template.service_provider_confirmation_code_body
    fill_in "Service provider confirmation code footer", with: @email_template.service_provider_confirmation_code_footer
    fill_in "Service provider confirmation code header", with: @email_template.service_provider_confirmation_code_header
    fill_in "Service provider otp confirmation body", with: @email_template.service_provider_otp_confirmation_body
    fill_in "Service provider otp confirmation footer", with: @email_template.service_provider_otp_confirmation_footer
    fill_in "Service provider otp confirmation header", with: @email_template.service_provider_otp_confirmation_header
    fill_in "Store manager number body", with: @email_template.store_manager_number_body
    fill_in "Store manager number footer", with: @email_template.store_manager_number_footer
    fill_in "Store manager number header", with: @email_template.store_manager_number_header
    fill_in "Store manager otp confirmation body", with: @email_template.store_manager_otp_confirmation_body
    fill_in "Store manager otp confirmation footer", with: @email_template.store_manager_otp_confirmation_footer
    fill_in "Store manager otp confirmation header", with: @email_template.store_manager_otp_confirmation_header
    fill_in "User invitation body", with: @email_template.user_invitation_body
    fill_in "User invitation footer", with: @email_template.user_invitation_footer
    fill_in "User invitation header", with: @email_template.user_invitation_header
    click_on "Create Email template"

    assert_text "Email template was successfully created"
    click_on "Back"
  end

  test "should update Email template" do
    visit email_template_url(@email_template)
    click_on "Edit this email template", match: :first

    fill_in "Admin otp confirmation body", with: @email_template.admin_otp_confirmation_body
    fill_in "Admin otp confirmation footer", with: @email_template.admin_otp_confirmation_footer
    fill_in "Admin otp confirmation header", with: @email_template.admin_otp_confirmation_header
    fill_in "Customer confirmation code body", with: @email_template.customer_confirmation_code_body
    fill_in "Customer confirmation code footer", with: @email_template.customer_confirmation_code_footer
    fill_in "Customer confirmation code header", with: @email_template.customer_confirmation_code_header
    fill_in "Customer otp confirmation body", with: @email_template.customer_otp_confirmation_body
    fill_in "Customer otp confirmation footer", with: @email_template.customer_otp_confirmation_footer
    fill_in "Customer otp confirmation header", with: @email_template.customer_otp_confirmation_header
    fill_in "Payment reminder body", with: @email_template.payment_reminder_body
    fill_in "Payment reminder footer", with: @email_template.payment_reminder_footer
    fill_in "Payment reminder header", with: @email_template.payment_reminder_header
    fill_in "Service provider confirmation code body", with: @email_template.service_provider_confirmation_code_body
    fill_in "Service provider confirmation code footer", with: @email_template.service_provider_confirmation_code_footer
    fill_in "Service provider confirmation code header", with: @email_template.service_provider_confirmation_code_header
    fill_in "Service provider otp confirmation body", with: @email_template.service_provider_otp_confirmation_body
    fill_in "Service provider otp confirmation footer", with: @email_template.service_provider_otp_confirmation_footer
    fill_in "Service provider otp confirmation header", with: @email_template.service_provider_otp_confirmation_header
    fill_in "Store manager number body", with: @email_template.store_manager_number_body
    fill_in "Store manager number footer", with: @email_template.store_manager_number_footer
    fill_in "Store manager number header", with: @email_template.store_manager_number_header
    fill_in "Store manager otp confirmation body", with: @email_template.store_manager_otp_confirmation_body
    fill_in "Store manager otp confirmation footer", with: @email_template.store_manager_otp_confirmation_footer
    fill_in "Store manager otp confirmation header", with: @email_template.store_manager_otp_confirmation_header
    fill_in "User invitation body", with: @email_template.user_invitation_body
    fill_in "User invitation footer", with: @email_template.user_invitation_footer
    fill_in "User invitation header", with: @email_template.user_invitation_header
    click_on "Update Email template"

    assert_text "Email template was successfully updated"
    click_on "Back"
  end

  test "should destroy Email template" do
    visit email_template_url(@email_template)
    click_on "Destroy this email template", match: :first

    assert_text "Email template was successfully destroyed"
  end
end
