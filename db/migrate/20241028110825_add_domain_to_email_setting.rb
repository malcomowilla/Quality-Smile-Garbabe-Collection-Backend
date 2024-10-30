class AddDomainToEmailSetting < ActiveRecord::Migration[7.1]
  def change
    add_column :email_settings, :domain, :string
  end
end
