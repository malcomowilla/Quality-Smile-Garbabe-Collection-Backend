class AddSystemUserToSms < ActiveRecord::Migration[7.1]
  def change
    add_column :sms, :system_user, :string
  end
end
