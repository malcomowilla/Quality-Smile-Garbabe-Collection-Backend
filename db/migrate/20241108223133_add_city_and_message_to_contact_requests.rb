class AddCityAndMessageToContactRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :contact_requests, :city, :string
    add_column :contact_requests, :mmessage, :string
  end
end
