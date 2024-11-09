class CompanySetting < ApplicationRecord
  acts_as_tenant(:account)
  has_one_attached :logo

  # validates :logo, content_type: ['image/png', 'image/jpeg', 'image/jpg'],
  # size: { less_than: 5.megabytes }
end
