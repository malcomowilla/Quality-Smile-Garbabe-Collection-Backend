class AddPasswordResetTokenToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :reset_password_token, :string
  end
end
