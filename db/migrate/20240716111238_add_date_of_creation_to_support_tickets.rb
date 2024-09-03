class AddDateOfCreationToSupportTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :support_tickets, :date_of_creation, :datetime
  end
end
