class AddDateRegisteredToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :date_registered, :date
  end
end
