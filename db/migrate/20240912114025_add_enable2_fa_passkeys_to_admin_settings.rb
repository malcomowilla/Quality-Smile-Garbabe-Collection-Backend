class AddEnable2FaPasskeysToAdminSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_settings, :enable_2fa_for_admin_passkeys, :boolean
  end
end
