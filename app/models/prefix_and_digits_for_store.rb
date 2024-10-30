class PrefixAndDigitsForStore < ApplicationRecord

  acts_as_tenant(:account)
end
