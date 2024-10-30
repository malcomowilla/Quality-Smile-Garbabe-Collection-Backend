class PrefixAndDigitsForTicketNumber < ApplicationRecord
  acts_as_tenant(:account)
end
