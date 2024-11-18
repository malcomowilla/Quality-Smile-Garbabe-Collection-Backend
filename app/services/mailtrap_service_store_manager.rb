# app/services/mailtrap_service_store_manager.rb
require "mailtrap"

class MailtrapServiceStoreManager
  def initialize(api_key)
    @client = Mailtrap::Client.new(api_key: api_key, api_host: "send.api.mailtrap.io")
  end

  def send_template_email(to:, template_uuid:, template_variables:, from: { email: "mailtrap@aitechsent.net", name: "store manager" }, subject: "Welcome to Quality Smiles")
    mail = Mailtrap::Mail::FromTemplate.new(
      from: from,
      to: [ { email: to } ],
      template_uuid: template_uuid,
      template_variables: template_variables,
      subject: subject,
      text: "This is a fallback text for email clients that do not support HTML." # Add this as fallback content
    )

    response = @client.send(mail)
    puts response
  end
end
# app/services/mailtrap_service_store_manager.rb
require "mailtrap"

class MailtrapServiceStoreManager
  def initialize(api_key)
    @client = Mailtrap::Client.new(api_key: api_key, api_host: "send.api.mailtrap.io")
  end

  def send_template_email(to:, template_uuid:, template_variables:, from: { email: "mailtrap@aitechsent.net", name: 
  "store manager" }, subject:"
manager number")
    mail = Mailtrap::Mail::FromTemplate.new(
      from: from,
      to: [ { email: to } ],
      template_uuid: template_uuid,
      template_variables: template_variables,
    )

    response = @client.send(mail)
    puts response
  end
end
