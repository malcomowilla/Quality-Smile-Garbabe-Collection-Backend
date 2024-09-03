class AddBooleansToPrefixAndDigitsForStoreManager < ActiveRecord::Migration[7.1]
  def change
    add_column :prefix_and_digits_for_store_managers, :send_manager_number_via_sms, :boolean
    add_column :prefix_and_digits_for_store_managers, :send_manager_number_via_email, :boolean
    add_column :prefix_and_digits_for_store_managers, :enable_2fa_for_store_manager, :boolean
  end
end
