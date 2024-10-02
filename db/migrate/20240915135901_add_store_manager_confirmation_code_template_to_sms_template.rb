class AddStoreManagerConfirmationCodeTemplateToSmsTemplate < ActiveRecord::Migration[7.1]
  def change
    add_column :sms_templates, :store_manager_manager_number_confirmation_template, :string
  end
end
