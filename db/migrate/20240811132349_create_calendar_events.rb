class CreateCalendarEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :calendar_events do |t|
      t.string :event_title
      t.datetime :start_date_time
      t.datetime :end_date_time

      t.timestamps
    end
  end
end
