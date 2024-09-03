class AddCanManageAndReadSupportTicketsToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_manage_tickets, :boolean
    add_column :admins, :can_read_tickets, :boolean
  end
end
