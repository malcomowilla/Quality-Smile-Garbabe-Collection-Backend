
class StoreManagerMailer < ApplicationMailer

  require_dependency 'mailtrap_service_store_manager'
  

def store_manager_send(store_manager)
  template_uuid = ENV['MAIL_TRAP_TEMPLATE_UUID_MANAGER_NUMBER']

  if template_uuid.nil? 
      Rails.logger.error "template uuid is nil"
  end
  @store_manager = store_manager
  MailtrapServiceStoreManager.new(ENV['MAIL_TRAP_API_KEY']).send_template_email(
    to: @store_manager.email,
    template_uuid: template_uuid,
    
    template_variables: {
      "user_name" => @store_manager.name,
      "manager_number" => @store_manager.manager_number,
      
    },
    
  )
end






end




































