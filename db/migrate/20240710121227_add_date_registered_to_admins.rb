class AddDateRegisteredToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :date_registered, :datetime
  end
end
