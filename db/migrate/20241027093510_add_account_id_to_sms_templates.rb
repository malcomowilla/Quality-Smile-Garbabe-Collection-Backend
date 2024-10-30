class AddAccountIdToSmsTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :sms_templates, :account_id, :integer
  end
end
