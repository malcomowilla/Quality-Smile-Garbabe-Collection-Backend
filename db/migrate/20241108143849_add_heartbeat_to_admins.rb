class AddHeartbeatToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :last_heartbeat, :datetime
  end
end
