class AddCanManageSmsAndSmsTemplatesToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :can_manage_sms, :boolean
    add_column :admins, :can_manage_sms_templates, :boolean
  end
end
