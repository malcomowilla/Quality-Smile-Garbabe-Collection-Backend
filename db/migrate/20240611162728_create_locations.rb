class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :location_name
      t.string :sub_location
      t.string :location_code
      t.string :category

      t.timestamps
    end
  end
end
