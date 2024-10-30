class AddAccountIdToSm < ActiveRecord::Migration[7.1]
  def change
    add_column :sms, :account_id, :integer
  end
end
