class AddAdditionalPermissionsToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_manage_customer_stats, :boolean
    add_column :admins, :can_read_customer_stats, :boolean
    add_column :admins, :can_manage_service_provider_stats, :boolean
    add_column :admins, :can_read_service_provider_stats, :boolean
    add_column :admins, :can_manage_individual_email, :boolean
    add_column :admins, :can_read_individual_email, :boolean
    add_column :admins, :can_manage_monitor_service_provider, :boolean
    add_column :admins, :can_read_monitor_service_provider, :boolean
  end
end
