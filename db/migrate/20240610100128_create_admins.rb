class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :user_name
      t.string :email
      t.string :password_digest
      t.string :phone_number

      t.timestamps
    end
  end
end
