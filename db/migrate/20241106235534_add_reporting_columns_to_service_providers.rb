class AddReportingColumnsToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :rating, :decimal, precision: 3, scale: 2, default: 0.0
    add_column :service_providers, :completion_rate, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :service_providers, :total_appointments, :integer, default: 0
    add_column :service_providers, :completed_appointments, :integer, default: 0
    add_column :service_providers, :cancelled_appointments, :integer, default: 0
    add_column :service_providers, :on_time_delivery_rate, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :service_providers, :active_status, :boolean, default: true
    add_column :service_providers, :last_active_at, :datetime
    add_timestamps :service_providers unless column_exists?(:service_providers, :created_at)
  end
end
