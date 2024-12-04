# class AddStartedAtToWorkSessions < ActiveRecord::Migration[7.0]
#   def change
#     add_column :work_sessions, :started_at, :datetime
#   end
# end


class AddStartedAtToWorkSessions < ActiveRecord::Migration[7.0]
  def up
    unless column_exists?(:work_sessions, :started_at)
      add_column :work_sessions, :started_at, :datetime
    else
      say "Column started_at already exists in work_sessions table"
    end
  end

  def down
    remove_column :work_sessions, :started_at if column_exists?(:work_sessions, :started_at)
  end
end



