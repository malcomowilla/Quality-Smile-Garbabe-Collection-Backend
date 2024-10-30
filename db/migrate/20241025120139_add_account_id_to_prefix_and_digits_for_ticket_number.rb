class AddAccountIdToPrefixAndDigitsForTicketNumber < ActiveRecord::Migration[7.1]
  def change
    add_column :prefix_and_digits_for_ticket_numbers, :account_id, :integer
  end
end
