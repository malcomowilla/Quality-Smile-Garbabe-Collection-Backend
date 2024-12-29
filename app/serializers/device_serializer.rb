class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :os, :ip_address, :device_token, :last_seen_at
  has_one :admin
end
