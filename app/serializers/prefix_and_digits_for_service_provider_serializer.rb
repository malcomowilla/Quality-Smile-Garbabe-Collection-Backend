class PrefixAndDigitsForServiceProviderSerializer < ActiveModel::Serializer
  attributes :id, :prefix, :minimum_digits

 attribute :use_auto_generated_number_for_service_provider, if: :include_use_auto_generated_number_for_service_provider? 

 attribute :send_sms_and_email_for_provider, if: :include_send_sms_and_email_for_provider



def include_send_sms_and_email_for_provider
  instance_options[:context][:send_sms_and_email_for_provider] == true

end






def include_use_auto_generated_number_for_service_provider?
  instance_options[:context][:use_auto_generated_number_for_service_provider] == true
end




def use_auto_generated_number_for_service_provider
  true
end


def send_sms_and_email_for_provider
  true
end

end
