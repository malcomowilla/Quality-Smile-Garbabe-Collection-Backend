class SmsSettingSerializer < ActiveModel::Serializer
  attributes :id, :api_key, :api_secret
end
