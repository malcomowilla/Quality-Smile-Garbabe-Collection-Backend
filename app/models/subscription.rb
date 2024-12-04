class Subscription < ApplicationRecord
  belongs_to :account
  has_many :payments

  validates :status, presence: true
  validates :amount_cents, presence: true
  validates :currency, presence: true

  enum status: {
    active: 'active',
    inactive: 'inactive',
    pending: 'pending',
    cancelled: 'cancelled'
  }

  def amount
    amount_cents / 100.0
  end

  def amount=(value)
    self.amount_cents = (value.to_f * 100).to_i
  end

  def active?
    status == 'active' && next_billing_date&.future?
  end

  def days_until_renewal
    return 0 unless next_billing_date
    (next_billing_date.to_date - Date.current).to_i
  end

  def renew!
    return false unless active?
    
    self.next_billing_date = 1.month.from_now
    save
  end

  def plan_details
    {
      name: plan_name,
      features: features,
      renewal_period: renewal_period
    }
  end
end
