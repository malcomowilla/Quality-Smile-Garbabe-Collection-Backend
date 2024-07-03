class AddOtpToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :otp, :string
  end
end
