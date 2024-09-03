class CreateSupportTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :support_tickets do |t|
      t.string :issue_description
      t.string :status
      t.string :priority
      t.string :agent
      t.string :ticket_number
      t.string :customer
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :date_created
      t.string :ticket_category

      t.timestamps
    end
  end
end
