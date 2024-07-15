class AddCanReadSmsAndSmsTemplatesToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_read_sms, :boolean
    add_column :admins, :can_read_sms_templates, :boolean
  end
end
