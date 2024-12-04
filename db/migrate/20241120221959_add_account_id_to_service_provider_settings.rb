class AddAccountIdToServiceProviderSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :service_provider_settings, :account_id, :integer
  end
end
