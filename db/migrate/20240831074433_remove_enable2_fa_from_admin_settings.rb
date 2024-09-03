class RemoveEnable2FaFromAdminSettings < ActiveRecord::Migration[7.1]
  def change
    remove_column :admin_settings, :enale_2fa_for_admin, :string
  end
end
