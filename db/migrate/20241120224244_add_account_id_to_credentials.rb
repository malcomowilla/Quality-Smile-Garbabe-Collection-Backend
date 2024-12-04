class AddAccountIdToCredentials < ActiveRecord::Migration[7.1]
  def change
    add_column :credentials, :account_id, :integer
  end
end
