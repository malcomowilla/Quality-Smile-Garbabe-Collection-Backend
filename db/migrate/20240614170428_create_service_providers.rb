class CreateServiceProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :service_providers do |t|
      t.string :phone_number
      t.string :name
      t.string :email
      t.string :provider_code
      t.string :status

      t.timestamps
    end
  end
end
