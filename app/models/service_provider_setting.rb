class ServiceProviderSetting < ApplicationRecord
    acts_as_tenant(:account)

end
