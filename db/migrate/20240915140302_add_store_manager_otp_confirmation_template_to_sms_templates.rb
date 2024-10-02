class AddStoreManagerOtpConfirmationTemplateToSmsTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :sms_templates, :store_manager_otp_confirmation_template, :string
  end
end
