class AddDeliveredAndCollectedToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :delivered, :boolean, default: false
    add_column :service_providers, :collected, :boolean, default: false
  end
end
