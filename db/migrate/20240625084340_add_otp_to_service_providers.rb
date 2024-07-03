class AddOtpToServiceProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :service_providers, :otp, :string
  end
end
