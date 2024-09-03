class AddCheckInactivityHrsAndDaysToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :check_inactive_days, :string
    add_column :admin_settings, :check_inactive_hrs, :string
  end
end
