class AddConfirmationDateToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :confirmation_date, :datetime
  end
end
