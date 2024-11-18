class AddVerificationToSystemAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admins, :verification_token, :string
    add_column :system_admins, :email_verified, :boolean, default: false
  end
end
