class AddWebauthnIdToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :webauthn_id, :string
  end
end
