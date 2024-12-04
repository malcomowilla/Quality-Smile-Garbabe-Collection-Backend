class SubscriptionsController < ApplicationController

  def status
    account = current_user&.account
    subscription = account ? Subscription.find_by(account: account) : nil

    if subscription
      render json: {
        plan_name: subscription.plan_name,
        features: subscription.features,
        renewal_period: subscription.renewal_period,
        active: subscription.active?,
        next_billing_date: subscription.next_billing_date,
        amount_cents: subscription.amount_cents
      }
    else
      
      # Create a default subscription if none exists
      subscription = Subscription.create!(
        account: account,
        status: 'inactive',
        plan_name: 'Enterprise',
        features: ['Waste Collection', 'Real-time Tracking', 'Analytics Dashboard', 'Customer Support', '24/7 Service'],
        renewal_period: 'monthly',
        amount_cents: 10000000, # 100,000 KES
        currency: 'KES',
        next_billing_date: Time.current + 1.month
      )

      render json: {
        plan_name: subscription.plan_name,
        features: subscription.features,
        renewal_period: subscription.renewal_period,
        active: subscription.active?,
        next_billing_date: subscription.next_billing_date,
        amount_cents: subscription.amount_cents
      }
    end
  rescue => e
    render json: { error: 'Failed to fetch subscription status', details: e.message }, status: :internal_server_error
  end
end