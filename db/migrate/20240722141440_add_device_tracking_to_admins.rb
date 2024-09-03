class AddDeviceTrackingToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :last_login_ip, :string
    add_column :admins, :last_login_at, :string
    add_column :admins, :current_device, :string
    add_column :admins, :inactive, :string
    add_column :admins, :last_activity_at, :string
  end
end
