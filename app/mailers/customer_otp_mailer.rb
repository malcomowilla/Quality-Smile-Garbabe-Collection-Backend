
class CustomerOtpMailer < ApplicationMailer

  require_dependency 'mailtrap_service'
  

def customers_otp(customer)
  template_uuid = ENV['MAIL_TRAP_TEMPLATE_UUID_CUSTOMER_OTP']
  @customer = customer
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @customer.email,
    template_uuid: template_uuid,
    template_variables: {
      "user_name" => @customer.name,
      "customer_otp" => @customer.otp,
      
    }
  )
end
end






































