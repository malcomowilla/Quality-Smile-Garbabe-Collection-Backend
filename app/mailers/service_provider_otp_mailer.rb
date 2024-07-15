
class ServiceProviderOtpMailer < ApplicationMailer

  require_dependency 'mailtrap_service'
  

def customer_code(customer)
  @customer = customer
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @customer.email,
    template_uuid: ENV['MAIL_TRAP_TEMPLATE_UUID'],
    template_variables: {
      "user_name" => @customer.name,
      "customer_code" => @customer.customer_code,
      
    }
  )
end
end




































