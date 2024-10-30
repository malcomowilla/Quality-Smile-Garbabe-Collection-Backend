class StoreManagerSetting < ApplicationRecord

  acts_as_tenant(:account)
end
