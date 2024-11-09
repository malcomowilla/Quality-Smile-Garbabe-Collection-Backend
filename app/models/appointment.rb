class Appointment < ApplicationRecord
  acts_as_tenant(:account)
  
  belongs_to :service_provider
  belongs_to :account

  validates :status, presence: true, inclusion: { in: %w[pending completed cancelled] }
  validates :service_provider_id, presence: true

  scope :completed, -> { where(status: 'completed') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :pending, -> { where(status: 'pending') }
  idates :service_provider_id, presence: true

  scope :completed, -> { where(status: 'completed') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :pending, -> { where(status: 'pending') }
  scope :created_after, ->(date) { where('appointments.created_at >= ?', date) }
  scope :created_before, ->(date) { where('appointments.created_at < ?', date) }
end