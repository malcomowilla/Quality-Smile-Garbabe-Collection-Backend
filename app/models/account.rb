class Account < ApplicationRecord
  

  has_many :admins
has_many :chat_messages
has_one :company_setting

has_many :service_providers
  
end
