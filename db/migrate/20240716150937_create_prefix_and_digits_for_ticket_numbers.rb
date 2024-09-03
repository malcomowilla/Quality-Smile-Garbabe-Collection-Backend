class CreatePrefixAndDigitsForTicketNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :prefix_and_digits_for_ticket_numbers do |t|
      t.string :prefix
      t.string :minimum_digits

      t.timestamps
    end
  end
end
