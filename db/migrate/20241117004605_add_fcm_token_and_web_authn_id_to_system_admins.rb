class AddFcmTokenAndWebAuthnIdToSystemAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admins, :fcm_token, :string
    add_column :system_admins, :webauthn_id, :string
  end
end
