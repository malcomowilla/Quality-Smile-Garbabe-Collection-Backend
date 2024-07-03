class AddOtpToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :otp, :string
  end
end
