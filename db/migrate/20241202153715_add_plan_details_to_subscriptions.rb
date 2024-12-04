class AddPlanDetailsToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :plan_name, :string, default: 'Enterprise'
    add_column :subscriptions, :features, :text, array: true, default: []
    add_column :subscriptions, :renewal_period, :string, default: 'monthly'
  end
end
