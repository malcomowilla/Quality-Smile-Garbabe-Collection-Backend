class ServiceProviderMailer < ApplicationMailer





    require_dependency 'mailtrap_service'
    


def service_provider_code(service_provider)
    @service_provider = service_provider
    template_uuid = ENV['MAIL_TRAP_SERVICE_PROVIDER']

    if template_uuid.nil? 
      Rails.logger.error "template uuid is nil"
  end
    MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
      to: @service_provider.email,
      template_uuid: template_uuid,
      template_variables: {
        "user_name" => @service_provider.name,
        "provider_code" => @service_provider.provider_code,
        
      }
    )
  end










end
