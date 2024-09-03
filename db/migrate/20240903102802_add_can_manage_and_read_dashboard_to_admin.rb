class AddCanManageAndReadDashboardToAdmin < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_manage_dashboard, :string
    add_column :admins, :can_read_dashboard, :string
  end
end
