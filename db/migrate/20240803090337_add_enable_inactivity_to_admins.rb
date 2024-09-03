class AddEnableInactivityToAdmins < ActiveRecord::Migration[7.1]
  def change

    add_column :admins, :enable_inactivity_check, :boolean, default: :false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
