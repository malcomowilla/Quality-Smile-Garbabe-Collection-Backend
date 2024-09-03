class CreateCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :credentials do |t|
      t.string :webauthn_id
      t.string :public_key
      t.integer :sign_count
      t.integer :admin_id

      t.timestamps
    end
  end
end
