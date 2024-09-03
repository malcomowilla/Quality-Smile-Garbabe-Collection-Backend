class RemoveCanManageCalendarAndCanReadCalendarFromAdmin < ActiveRecord::Migration[7.1]
  def change
    remove_column :admins, :can_manage_calendar, :string
    remove_column :admins, :can_read_calendar, :string
  end
end
