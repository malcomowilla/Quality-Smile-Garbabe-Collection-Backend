class Account < ApplicationRecord
  

  has_many :admins
has_many :chat_messages


  
end
