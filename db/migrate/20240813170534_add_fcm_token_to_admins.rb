class AddFcmTokenToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :fcm_token, :string
  end
end
