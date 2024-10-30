class AddCustomerSequenceStartingValueToCustomerSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :customer_settings, :sequence_value, :integer
  end
end
