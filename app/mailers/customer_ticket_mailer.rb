

class CustomerTicketMailer < ApplicationMailer
 




  require_dependency 'mailtrap_service'
  

def customer_ticket_mailer(ticket_number, ticket_created_at, 
  customer_email, issue_description, ticket_status, ticket_priority,
  customer_code)


  @ticket_priority = ticket_priority
  @ticket_status = ticket_status
  @customer_email = customer_email
  @ticket_number = ticket_number
  @ticket_created_at = ticket_created_at
  @issue_description = issue_description
  @customer_code = customer_code



  template_uuid = ENV['MAIL_TRAP_CUSTOMER_TICKETS']

  if template_uuid.nil? 
    Rails.logger.error "template uuid is nil"
end

  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @customer_email,
    template_uuid: template_uuid,
    template_variables: {
      
      "customer_email" => @customer_email,
       "ticket_created_at" => @ticket_created_at,
       "ticket_number" => @ticket_number,
       "issue_description" => @issue_description,
       "ticket_status" => @ticket_status,
       "ticket_priority" => @ticket_priority,
       "customer_portal_link" => "https://aitechs-sas-garbage-solution.onrender.com/customer_role?my_customer_code=#{@customer_code}"
      
    }
  )
end
end






































