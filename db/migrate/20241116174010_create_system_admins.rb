class CreateSystemAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :system_admins do |t|
      t.string :user_name
      t.string :password_digest
      t.string :email

      t.timestamps
    end
  end
end
