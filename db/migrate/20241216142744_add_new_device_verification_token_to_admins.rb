class AddNewDeviceVerificationTokenToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :device_verification_token, :string
    add_column :admins, :device_verification_token_sent_at, :datetime
  end
end
