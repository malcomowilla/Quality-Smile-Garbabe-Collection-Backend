
class AdminSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :phone_number, :email, :role, :formatted_registered_date,
  :can_read_finances_account, :can_manage_finances_account, :can_read_invoice, 
  :can_manage_invoice, :can_read_sub_location, :can_manage_sub_location, 
  :can_read_location, :can_manage_location, :can_read_store_manager, 
  :can_manage_store_manager, :can_read_store, :can_manage_store, 
  :can_read_service_provider, :can_manage_service_provider, 
  :can_manage_customers, :can_read_customers, :can_read_settings, 
  :can_manage_settings, :can_manage_payment, :can_read_payment, :can_manage_sms_templates,
  :can_manage_sms, :can_read_sms_templates, :can_read_sms, :can_manage_tickets,
  :can_read_tickets ,:last_activity_active, :formatted_last_activity_active,
:profile_image,:can_manage_calendar,
:can_read_calendar
  

# def initialize(object, options = {})
# super(object, options)

# # Set default values based on role only for 'super_admin'
# if object.role == 'super_administrator'
#   object.can_read_finances_account = false
#   object.can_manage_finances_account = true
#   object.can_read_invoice = false
#   object.can_manage_invoice = true
#   object.can_read_sub_location = false
#   object.can_manage_sub_location = true
#   object.can_read_location = false
#   object.can_manage_location = true
#   object.can_read_store_manager = false
#   object.can_manage_store_manager = true
#   object.can_read_store = false
#   object.can_manage_store = true
#   object.can_read_service_provider = false
#   object.can_manage_service_provider = true
#   object.can_manage_customers = true
#   object.can_read_customers = false
#   object.can_read_settings = false
#   object.can_manage_settings = true
#   object.can_manage_payment = true
#   object.can_read_payment = false

# # else
# #   object.can_read_finances_account = false
# #   object.can_manage_finances_account = false
# #   object.can_read_invoice = false
# #   object.can_manage_invoice = false
# #   object.can_read_sub_location = false
# #   object.can_manage_sub_location = false
# #   object.can_read_location = false
# #   object.can_manage_location = false
# #   object.can_read_store_manager = false
# #   object.can_manage_store_manager = false
# #   object.can_read_store = false
# #   object.can_manage_store = false
# #   object.can_read_service_provider = false
# #   object.can_manage_service_provider = false
# #   object.can_manage_customers = false
# #   object.can_read_customers = false
# #   object.can_read_settings = false
# #   object.can_manage_settings = false
# #   object.can_manage_payment = false
# #   object.can_read_payment = false


# end
# end



def formatted_last_activity_active
  object.last_activity_active.strftime('%Y-%m-%d %I:%M:%S %p') if object.last_activity_active.present?
end

def formatted_registered_date
object.date_registered.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_registered.present?
end



end











# class AdminSerializer < ActiveModel::Serializer
#   attributes :id, :user_name, :phone_number,:email,:role, :can_read_finances_account, 
#   :can_manage_finances_account,:can_read_invoice, :can_manage_invoice, :can_read_sub_location, :can_manage_sub_location, 
#   :can_manage_sub_location, :can_read_location, :can_manage_location, :can_read_store_manager, :can_manage_store_manager,
#   :can_read_store, :can_manage_store, :can_read_service_provider, :can_manage_service_provider, :can_manage_customers,
#   :can_read_customers, :can_read_settings, :can_manage_settings, :can_manage_payment, :can_read_payment,
#    :formatted_registered_date




#   def formatted_registered_date
#     object.date_registered.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_registered.present?
#   end
# end





