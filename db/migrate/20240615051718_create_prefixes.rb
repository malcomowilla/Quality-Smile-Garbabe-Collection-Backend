class CreatePrefixes < ActiveRecord::Migration[7.1]
  def change
    create_table :prefixes do |t|
      t.string :minimum_digits

      t.timestamps
    end
  end
end
