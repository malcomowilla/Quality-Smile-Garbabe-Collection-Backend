class AddOtpToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :otp, :string
  end
end
