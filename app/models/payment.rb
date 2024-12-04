class Payment < ApplicationRecord
    acts_as_tenant(:account)

    belongs_to :subscription

  after_update :activate_subscription, if: -> { saved_change_to_status? && status == 'completed' }

  def amount
    amount_cents / 100.0 # Convert cents to actual amount
  end

  private

  def activate_subscription
    subscription.update(
      status: 'active',
      last_payment_date: Time.current,
      next_billing_date: Time.current + 1.month
    )
  end
end
