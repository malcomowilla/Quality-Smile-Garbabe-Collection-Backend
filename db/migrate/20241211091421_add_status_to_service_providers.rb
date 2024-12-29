class AddStatusToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :status, :string, default: 'not_available'
  end
end
