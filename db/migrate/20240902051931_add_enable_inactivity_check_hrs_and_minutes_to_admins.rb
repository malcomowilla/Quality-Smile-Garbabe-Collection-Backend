class AddEnableInactivityCheckHrsAndMinutesToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :enable_inactivity_check_minutes, :boolean
    add_column :admins, :enable_inactivity_check_hours, :boolean
  end
end
