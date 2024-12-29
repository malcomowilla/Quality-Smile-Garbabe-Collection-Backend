class AddAvailabilityToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :availability, :string, default: "not_available"
  end
end
