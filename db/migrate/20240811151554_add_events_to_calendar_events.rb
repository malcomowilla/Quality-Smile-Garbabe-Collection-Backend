class AddEventsToCalendarEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :calendar_events, :title, :string
    add_column :calendar_events, :start, :datetime
    add_column :calendar_events, :end, :datetime
  end
end
