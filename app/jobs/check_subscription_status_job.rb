class CheckSubscriptionStatusJob < ApplicationJob
  queue_as :default

  def perform
    # Find all active subscriptions
    Subscription.where(status: 'active').find_each do |subscription|
      if subscription.next_billing_date.present? && subscription.next_billing_date < Time.current
        # Subscription has expired
        subscription.update(status: 'expired')
        
        # Notify account admins
        subscription.account.admins.each do |admin|
          AdminMailer.subscription_expired(admin, subscription).deliver_later
        end
      elsif subscription.next_billing_date.present? && subscription.next_billing_date < 3.days.from_now
        # Subscription is about to expire
        subscription.account.admins.each do |admin|
          AdminMailer.subscription_expiring_soon(admin, subscription).deliver_later
        end
      end
    end
  end
end
