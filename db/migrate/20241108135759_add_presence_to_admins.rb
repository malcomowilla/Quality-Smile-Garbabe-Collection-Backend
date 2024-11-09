class AddPresenceToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :online, :boolean, default: false
    add_column :admins, :last_seen, :datetime
  end
end
