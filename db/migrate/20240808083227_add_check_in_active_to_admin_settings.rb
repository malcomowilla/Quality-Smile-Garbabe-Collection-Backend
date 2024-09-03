class AddCheckInActiveToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :check_is_inactive, :boolean
  end
end
