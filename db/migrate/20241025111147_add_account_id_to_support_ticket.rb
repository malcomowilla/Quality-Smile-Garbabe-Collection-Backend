class AddAccountIdToSupportTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :support_tickets, :account_id, :integer
  end
end
