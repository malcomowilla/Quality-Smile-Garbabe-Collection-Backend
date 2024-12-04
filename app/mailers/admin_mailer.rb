class AdminMailer < ApplicationMailer
  def password_reset(admin, new_password)
    @admin = admin
    @new_password = new_password
    mail(
      from: tenant_sender_email,
      to: @admin.email,
      subject: 'Your Password Has Been Reset'
    )
  end

  def subscription_expired(admin, subscription)
    @admin = admin
    @subscription = subscription
    mail(
      from: tenant_sender_email,
      to: @admin.email,
      subject: 'Your Subscription Has Expired'
    )
  end

  def subscription_expiring_soon(admin, subscription)
    @admin = admin
    @subscription = subscription
    @days_remaining = (subscription.next_billing_date.to_date - Date.current).to_i
    mail(
      from: tenant_sender_email,
      to: @admin.email,
      subject: 'Your Subscription is Expiring Soon'
    )
  end

  def payment_successful(payment)
    @payment = payment
    @subscription = payment.subscription
    @admin = payment.subscription.account.admins.first
    mail(
      from: tenant_sender_email,
      to: @admin.email,
      subject: 'Payment Successful - Subscription Updated'
    )
  end
end
