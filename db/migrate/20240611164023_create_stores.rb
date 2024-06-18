class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :amount_of_bags
      t.string :status
      t.boolean :from_store
      t.string :location

      t.timestamps
    end
  end
end
