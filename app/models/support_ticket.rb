class SupportTicket < ApplicationRecord

  acts_as_tenant(:account)
  auto_increment :sequence_number

end


