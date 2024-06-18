class AddAdminIdToPrefixAndDigits < ActiveRecord::Migration[7.1]
  def change
    add_column :prefix_and_digits, :admin_id, :integer
  end
end
