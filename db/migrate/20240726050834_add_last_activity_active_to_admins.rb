class AddLastActivityActiveToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :last_activity_active, :datetime
  end
end
