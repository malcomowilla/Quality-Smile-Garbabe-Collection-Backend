require "test_helper"

class EmailTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email_template = email_templates(:one)
  end

  test "should get index" do
    get email_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_email_template_url
    assert_response :success
  end

  test "should create email_template" do
    assert_difference("EmailTemplate.count") do
      post email_templates_url, params: { email_template: { admin_otp_confirmation_body: @email_template.admin_otp_confirmation_body, admin_otp_confirmation_footer: @email_template.admin_otp_confirmation_footer, admin_otp_confirmation_header: @email_template.admin_otp_confirmation_header, customer_confirmation_code_body: @email_template.customer_confirmation_code_body, customer_confirmation_code_footer: @email_template.customer_confirmation_code_footer, customer_confirmation_code_header: @email_template.customer_confirmation_code_header, customer_otp_confirmation_body: @email_template.customer_otp_confirmation_body, customer_otp_confirmation_footer: @email_template.customer_otp_confirmation_footer, customer_otp_confirmation_header: @email_template.customer_otp_confirmation_header, payment_reminder_body: @email_template.payment_reminder_body, payment_reminder_footer: @email_template.payment_reminder_footer, payment_reminder_header: @email_template.payment_reminder_header, service_provider_confirmation_code_body: @email_template.service_provider_confirmation_code_body, service_provider_confirmation_code_footer: @email_template.service_provider_confirmation_code_footer, service_provider_confirmation_code_header: @email_template.service_provider_confirmation_code_header, service_provider_otp_confirmation_body: @email_template.service_provider_otp_confirmation_body, service_provider_otp_confirmation_footer: @email_template.service_provider_otp_confirmation_footer, service_provider_otp_confirmation_header: @email_template.service_provider_otp_confirmation_header, store_manager_number_body: @email_template.store_manager_number_body, store_manager_number_footer: @email_template.store_manager_number_footer, store_manager_number_header: @email_template.store_manager_number_header, store_manager_otp_confirmation_body: @email_template.store_manager_otp_confirmation_body, store_manager_otp_confirmation_footer: @email_template.store_manager_otp_confirmation_footer, store_manager_otp_confirmation_header: @email_template.store_manager_otp_confirmation_header, user_invitation_body: @email_template.user_invitation_body, user_invitation_footer: @email_template.user_invitation_footer, user_invitation_header: @email_template.user_invitation_header } }
    end

    assert_redirected_to email_template_url(EmailTemplate.last)
  end

  test "should show email_template" do
    get email_template_url(@email_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_email_template_url(@email_template)
    assert_response :success
  end

  test "should update email_template" do
    patch email_template_url(@email_template), params: { email_template: { admin_otp_confirmation_body: @email_template.admin_otp_confirmation_body, admin_otp_confirmation_footer: @email_template.admin_otp_confirmation_footer, admin_otp_confirmation_header: @email_template.admin_otp_confirmation_header, customer_confirmation_code_body: @email_template.customer_confirmation_code_body, customer_confirmation_code_footer: @email_template.customer_confirmation_code_footer, customer_confirmation_code_header: @email_template.customer_confirmation_code_header, customer_otp_confirmation_body: @email_template.customer_otp_confirmation_body, customer_otp_confirmation_footer: @email_template.customer_otp_confirmation_footer, customer_otp_confirmation_header: @email_template.customer_otp_confirmation_header, payment_reminder_body: @email_template.payment_reminder_body, payment_reminder_footer: @email_template.payment_reminder_footer, payment_reminder_header: @email_template.payment_reminder_header, service_provider_confirmation_code_body: @email_template.service_provider_confirmation_code_body, service_provider_confirmation_code_footer: @email_template.service_provider_confirmation_code_footer, service_provider_confirmation_code_header: @email_template.service_provider_confirmation_code_header, service_provider_otp_confirmation_body: @email_template.service_provider_otp_confirmation_body, service_provider_otp_confirmation_footer: @email_template.service_provider_otp_confirmation_footer, service_provider_otp_confirmation_header: @email_template.service_provider_otp_confirmation_header, store_manager_number_body: @email_template.store_manager_number_body, store_manager_number_footer: @email_template.store_manager_number_footer, store_manager_number_header: @email_template.store_manager_number_header, store_manager_otp_confirmation_body: @email_template.store_manager_otp_confirmation_body, store_manager_otp_confirmation_footer: @email_template.store_manager_otp_confirmation_footer, store_manager_otp_confirmation_header: @email_template.store_manager_otp_confirmation_header, user_invitation_body: @email_template.user_invitation_body, user_invitation_footer: @email_template.user_invitation_footer, user_invitation_header: @email_template.user_invitation_header } }
    assert_redirected_to email_template_url(@email_template)
  end

  test "should destroy email_template" do
    assert_difference("EmailTemplate.count", -1) do
      delete email_template_url(@email_template)
    end

    assert_redirected_to email_templates_url
  end
end
