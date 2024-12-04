class ServiceProviderLocation < ApplicationRecord
  acts_as_tenant(:account)
  
  belongs_to :service_provider
  belongs_to :account

  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :address, presence: true
end
