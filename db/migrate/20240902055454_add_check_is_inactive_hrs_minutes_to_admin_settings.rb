class AddCheckIsInactiveHrsMinutesToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :check_is_inactivehrs, :boolean
    add_column :admin_settings, :check_is_inactiveminutes, :boolean
  end
end
