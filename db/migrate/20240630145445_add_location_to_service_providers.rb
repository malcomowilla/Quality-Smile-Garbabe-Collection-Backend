class AddLocationToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :location, :string
  end
end
