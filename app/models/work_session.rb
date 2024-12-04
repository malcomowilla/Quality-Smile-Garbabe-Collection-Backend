class WorkSession < ApplicationRecord
  belongs_to :admin
  # acts_as_tenant(:account)
  validates :date, presence: true
  validates :admin_id, presence: true
  
  # Ensure only one session per admin per day
  validates :admin_id, uniqueness: { scope: :date, message: "can only have one session per day" }
  
  # Scopes
  scope :today, -> { where(date: Date.current) }
  scope :for_admin, ->(admin_id) { where(admin_id: admin_id) }
end
