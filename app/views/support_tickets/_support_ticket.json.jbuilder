json.extract! support_ticket, :id, :issue_description, :status, :priority, :agent, :ticket_number, :customer, :name, :email, :phone_number, :date_created, :ticket_category, :created_at, :updated_at
json.url support_ticket_url(support_ticket, format: :json)
