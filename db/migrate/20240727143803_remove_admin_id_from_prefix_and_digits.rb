class RemoveAdminIdFromPrefixAndDigits < ActiveRecord::Migration[7.1]
  def change
    remove_column :prefix_and_digits, :admin_id, :integer
  end
end
