class RemoveAdminIdFromPrefixAndDigitsForServiceProvider < ActiveRecord::Migration[7.1]
  def change
    remove_column :prefix_and_digits_for_service_providers, :admin_id, :integer
  end
end
