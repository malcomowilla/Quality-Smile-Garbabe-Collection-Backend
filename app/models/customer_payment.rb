class CustomerPayment < ApplicationRecord
    acts_as_tenant(:account)

end