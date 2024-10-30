class AddAccountIdToSubLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :sub_locations, :account_id, :integer
  end
end
