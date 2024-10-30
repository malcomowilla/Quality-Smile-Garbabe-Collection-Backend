class EmailSetting < ApplicationRecord
  # encrypts :smtp_username, :smtp_password,:api_key, deterministic: true   

  acts_as_tenant(:account)
  

end
