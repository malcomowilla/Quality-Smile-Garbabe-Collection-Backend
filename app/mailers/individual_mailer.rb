class IndividualMailer < ApplicationMailer
    # Set default sender email at the class level
    


    def send_individual_email(to:, subject:, message:)
        @message = message
        
      
        
        variables = {
          message: @message
        }
        
        # @customer_confirmation_code_body = MyEmailTemplate.interpolate( @message, { customer_code: @customer.customer_code, name: @customer.name, email: @customer.email, user_name: @admin.user_name})

    mail(
        from: tenant_sender_email,
        to: to,
        subject: subject,
        # category: 'Test category'
    ) do |format|
      format.html { render 'send_individual_email' }
      format.text { render 'send_individual_email' }
    end
end
end
