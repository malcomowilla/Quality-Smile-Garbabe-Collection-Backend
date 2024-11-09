

class ServiceProvider < ApplicationRecord
    # Associations
    # has_many :services
    # has_many :appointments
    #acts_as_tenant(:account)
    acts_as_tenant(:account)

  has_many :appointments, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :with_completed_appointments, -> { joins(:appointments).where(appointments: { status: 'completed' }) }
  scope :with_cancelled_appointments, -> { joins(:appointments).where(appointments: { status: 'cancelled' }) }

  # Add any validations you need
  validates :name, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  has_many :appointments, class_name: 'Appointment', dependent: :destroy

  end


