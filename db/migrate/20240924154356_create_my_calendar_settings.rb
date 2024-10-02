class CreateMyCalendarSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :my_calendar_settings do |t|
      t.string :start_in_minutes
      t.string :start_in_hours

      t.timestamps
    end
  end
end
