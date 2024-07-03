class ServiceProviderMailer < ApplicationMailer





    require_dependency 'mailtrap_service'
    


def service_provider_code(service_provider)
    @service_provider = service_provider
    MailtrapService.new('f17620673c51e537ef268dea49025da8').send_template_email(
      to: @customer.email,
      template_uuid: ENV['MAIL_TRAP_TEMPLATE_UUID'],
      template_variables: {
        "user_name" => @service_provider.name,
        "provider_code" => @service_provider.provider_code,
        
      }
    )
  end










end
