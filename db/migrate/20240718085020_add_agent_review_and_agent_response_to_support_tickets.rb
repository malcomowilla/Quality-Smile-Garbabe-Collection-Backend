class AddAgentReviewAndAgentResponseToSupportTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :support_tickets, :agent_review, :string
    add_column :support_tickets, :agent_response, :string
  end
end
