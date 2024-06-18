class CreateSubLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :sub_locations do |t|
      t.string :name
      t.string :code
      t.string :created_by
      t.string :category

      t.timestamps
    end
  end
end
