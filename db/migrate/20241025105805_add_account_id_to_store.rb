class AddAccountIdToStore < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :account_id, :integer
  end
end
