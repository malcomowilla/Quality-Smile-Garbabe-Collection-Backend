class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :os
      t.string :ip_address
      t.string :device_token
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end
