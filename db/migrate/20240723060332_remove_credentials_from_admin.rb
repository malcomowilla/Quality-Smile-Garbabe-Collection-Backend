class RemoveCredentialsFromAdmin < ActiveRecord::Migration[7.1]
  def change
    remove_column :admins, :webauthn_id, :string
    remove_column :admins, :webauthn_public_key, :string
    remove_column :admins, :webauthn_sign_count, :integer
  end
end
