class CanManageAndReadCalendarToAdmins < ActiveRecord::Migration[7.1]
  def change

    add_column :admins, :can_manage_calendar, :boolean
    add_column :admins, :can_read_calendar, :boolean
  end
end
