class AddConfirmRequestToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :confirm_request, :boolean, default: false
  end
end
