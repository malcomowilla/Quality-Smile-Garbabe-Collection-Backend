class CreateWorkSessions < ActiveRecord::Migration[7.0]
  def up
    if !table_exists?(:work_sessions)
      create_table :work_sessions do |t|
        t.references :admin, null: false, foreign_key: true
        t.date :date, null: false
        t.datetime :last_active_at
        t.integer :total_time_seconds, default: 0

        t.timestamps
      end
      
      add_index :work_sessions, [:admin_id, :date], unique: true
    else
      say "work_sessions table already exists, skipping creation"
    end
  end

  def down
    drop_table :work_sessions if table_exists?(:work_sessions)
  end
end