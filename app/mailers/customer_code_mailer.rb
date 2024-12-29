class CustomerCodeMailer < ApplicationMailer

    # require_dependency 'mailtrap_service'
    

def customer_code(customer)
    # @customer = customer
    # MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    #   to: @customer.email,
    #   template_uuid: ENV['MAIL_TRAP_TEMPLATE_UUID'],
    #   template_variables: {
    #     "user_name" => @customer.name,
    #     "customer_code" => @customer.customer_code,
        
    #   }
    # )
    @customer = customer
    @customer_code = customer.customer_code  # Assuming `code` is an attribute on the Customer model
    @customer_confirmation_code_header = EmailTemplate.first&.password_reset_header
    @customer_confirmation_code_header = MyEmailTemplate.interpolate(@customer_confirmation_code_header, {name: @customer.name})
    @customer_confirmation_code_body = EmailTemplate.first&.password_reset_body
    @customer_confirmation_code_body = MyEmailTemplate.interpolate(@customer_confirmation_code_body, { customer_code: @customer.customer_code, name: @customer.name, email: @customer.email})
    @customer_confirmation_code_footer = EmailTemplate.first&.password_reset_footer
    @customer_confirmation_code_footer = MyEmailTemplate.interpolate(@customer_confirmation_code_footer, {name: @customer.name})
 @company_name = CompanySetting.first&.company_name

mail(
  from: tenant_sender_email,
  to: customer.email,
  subject: 'Your Customer Code',
  category: 'Customer Code',
 
)

  end
end














