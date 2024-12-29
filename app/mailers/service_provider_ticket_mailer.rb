

class ServiceProviderTicketMailer < ApplicationMailer
  def send_ticket_email(service_provider,
    ticket_number, ticket_created_at, 
    customer_email, issue_description, ticket_status, ticket_priority,
    customer_code, customer_portal_link, company_name,
    customer_support_email,service_provider_email
  
    )


    @service_provider = service_provider
 @service_provider_name =   @service_provider


 @ticket_priority = ticket_priority
 @ticket_status = ticket_status
 @customer_email = customer_email
 @ticket_number = ticket_number
 @ticket_created_at = ticket_created_at
 @issue_description = issue_description
 @customer_code = customer_code
 @customer_portal_link = customer_portal_link
 @company_name = company_name
 @customer_support_email = customer_support_email

    mail(to: service_provider_email, subject: 'Customer Ticket Created',
    from: tenant_sender_email,
    )
  end


end