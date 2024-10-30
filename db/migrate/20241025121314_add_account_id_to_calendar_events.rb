class AddAccountIdToCalendarEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :calendar_events, :account_id, :integer
  end
end
