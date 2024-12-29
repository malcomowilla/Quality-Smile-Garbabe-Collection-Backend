class AddTotalDeliveredAndTotalConfirmationsToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :total_delivered_confirmation, :integer, default: 0
    add_column :service_providers, :total_collection_confirmation, :integer, default: 0
  end

end