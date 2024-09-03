class CreateAdminSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_settings do |t|
      t.boolean :login_with_otp
      t.boolean :login_with_web_auth
      t.boolean :login_with_otp_email
      t.boolean :send_password_via_sms
      t.boolean :send_password_via_email

      t.timestamps
    end
  end
end
