class PrefixAndDigitsForStoreManagerSerializer < ActiveModel::Serializer
  attributes :id, :prefix, :minimum_digits, :send_manager_number_via_sms, :send_manager_number_via_email,
  :enable_2fa_for_store_manager







# attribute :send_manager_number_via_sms, if: :include_send_manager_number_via_sms? 
# attribute :send_manager_number_via_email, if: :include_send_manager_number_via_email? 
# attribute :enable_2fa_for_store_manager, if: :include_enable_2fa_for_store_manager?

# def include_send_manager_number_via_sms?
#   instance_options[:context][:send_manager_number_via_sms] == true ||  instance_options[:context][:send_manager_number_via_sms] == 'true'
# end


# def include_enable_2fa_for_store_manager?
#   instance_options[:context][:enable_2fa_for_store_manager] == true || instance_options[:context][:enable_2fa_for_store_manager] == 'true'
# end



# def include_send_manager_number_via_email?
#   instance_options[:context][:send_manager_number_via_email] == true || instance_options[:context][:enable_2fa_for_store_manager] == 'true'
# end


# def send_manager_number_via_sms
#   true
# end



# def send_manager_number_via_email
#   true
# end

# def enable_2fa_for_store_manager
#   true
# end


end