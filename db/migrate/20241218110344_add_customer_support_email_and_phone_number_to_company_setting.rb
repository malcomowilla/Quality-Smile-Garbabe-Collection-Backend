class AddCustomerSupportEmailAndPhoneNumberToCompanySetting < ActiveRecord::Migration[7.1]
  def change
    add_column :company_settings, :customer_support_email, :string
    add_column :company_settings, :agent_email, :string
    add_column :company_settings, :customer_support_phone_number, :string
  end
end
