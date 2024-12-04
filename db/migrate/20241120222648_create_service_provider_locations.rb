class CreateServiceProviderLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :service_provider_locations do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :address
      t.references :service_provider, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
