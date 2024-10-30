class AddAccountIdToLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :account_id, :integer
  end
end
