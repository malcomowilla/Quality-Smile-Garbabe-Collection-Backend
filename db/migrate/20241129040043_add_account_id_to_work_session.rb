class AddAccountIdToWorkSession < ActiveRecord::Migration[7.1]
  def change
    add_column :work_sessions, :account_id, :integer
  end
end
