class AddPermissionsToAdmin < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_read_payment, :boolean
    add_column :admins, :can_manage_payment, :boolean
    add_column :admins, :can_manage_settings, :boolean
    add_column :admins, :can_read_settings, :boolean
    add_column :admins, :can_read_customers, :boolean
    add_column :admins, :can_manage_customers, :boolean
    add_column :admins, :can_manage_service_provider, :boolean
    add_column :admins, :can_read_service_provider, :boolean
    add_column :admins, :can_manage_store, :boolean
    add_column :admins, :can_read_store, :boolean
    add_column :admins, :can_manage_store_manager, :boolean
    add_column :admins, :can_read_store_manager, :boolean
    add_column :admins, :can_manage_location, :boolean
    add_column :admins, :can_read_location, :boolean
    add_column :admins, :can_manage_sub_location, :boolean
    add_column :admins, :can_read_sub_location, :boolean
    add_column :admins, :can_manage_invoice, :boolean
    add_column :admins, :can_read_invoice, :boolean
    add_column :admins, :can_manage_finances_account, :boolean
    add_column :admins, :can_read_finances_account, :boolean
  end
end
