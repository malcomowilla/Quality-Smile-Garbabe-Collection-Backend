class AddCheckInactiveMinutesToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :check_inactive_minutes, :string
  end
end
