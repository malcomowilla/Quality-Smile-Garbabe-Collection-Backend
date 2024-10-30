class AddAccountIdToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :account_id, :integer
  end
end
