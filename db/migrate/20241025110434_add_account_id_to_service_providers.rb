class AddAccountIdToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :account_id, :integer
  end
end
