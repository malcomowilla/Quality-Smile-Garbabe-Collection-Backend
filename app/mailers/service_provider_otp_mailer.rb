
class ServiceProviderOtpMailer < ApplicationMailer

  require_dependency 'mailtrap_service'
  

def provider_otp(service_provider)
  @service_provider = service_provider
  template_uuid = ENV['MAIL_TRAP_SERVICE_PROVIDER_OTP']
  MailtrapService.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @service_provider.email,
    template_uuid: template_uuid,
    template_variables: {
      "user_name" => @service_provider.name,
      "service_provider_otp" => @service_provider.otp,
      
    }
  )
end
end




































