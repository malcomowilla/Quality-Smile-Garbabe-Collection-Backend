class AddLongitudeAndLatitudeToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :longitude, :string
    add_column :service_providers, :latitude, :string
  end
end
