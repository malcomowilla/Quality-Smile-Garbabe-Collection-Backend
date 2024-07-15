class AddAdminUserToSms < ActiveRecord::Migration[7.1]
  def change
    add_column :sms, :admin_user, :string
  end
end
