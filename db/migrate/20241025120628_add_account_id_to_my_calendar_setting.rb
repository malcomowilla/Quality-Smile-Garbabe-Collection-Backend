class AddAccountIdToMyCalendarSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :my_calendar_settings, :account_id, :integer
  end
end
