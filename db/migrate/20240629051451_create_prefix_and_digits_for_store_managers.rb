class CreatePrefixAndDigitsForStoreManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :prefix_and_digits_for_store_managers do |t|
      t.string :prefix
      t.string :minimum_digits

      t.timestamps
    end
  end
end
