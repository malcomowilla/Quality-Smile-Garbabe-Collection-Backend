class AddDateClosedToSupportTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :support_tickets, :date_closed, :datetime
  end
end
