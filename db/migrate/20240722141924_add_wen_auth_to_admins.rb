class AddWenAuthToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :webauthn_sign_count, :integer
    add_column :admins, :webauthn_public_key, :binary
    add_column :admins, :webauthn_id, :string
    add_column :admins, :webauthn_authenticator_attachment, :jsonb
  end
end
