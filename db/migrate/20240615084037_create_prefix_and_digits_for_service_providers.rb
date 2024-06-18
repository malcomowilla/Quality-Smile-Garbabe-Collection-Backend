class CreatePrefixAndDigitsForServiceProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :prefix_and_digits_for_service_providers do |t|
      t.string :prefix
      t.string :minimum_digits

      t.timestamps
    end
  end
end
