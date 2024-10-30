class CustomerSetting < ApplicationRecord
  acts_as_tenant(:account)
end
