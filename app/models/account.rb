class Account < ApplicationRecord
  
  has_one :subscription
  has_many :admins
has_many :chat_messages
has_one :company_setting
has_one :prefix_and_digits_for_ticket_number
has_one :email_setting
has_many :service_providers
has_one :theme_setting
has_many :work_sessions
has_many :customers
  validates  :subdomain, uniqueness: true
end



