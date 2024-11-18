class AddWebAuthAttachmentToSystemAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :system_admins, :webauthn_authenticator_attachment, :jsonb
  end
end
