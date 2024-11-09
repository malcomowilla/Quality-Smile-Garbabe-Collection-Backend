class AddPasswordResetHeaderBodyAndFooterToEmailTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :email_templates, :password_reset_header, :string
    add_column :email_templates, :password_reset_body, :string
    add_column :email_templates, :password_reset_footer, :string
  end
end
