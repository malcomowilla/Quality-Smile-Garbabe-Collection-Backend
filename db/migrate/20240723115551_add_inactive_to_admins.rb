class AddInactiveToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column   :admins, :inactive, :boolean, default: false

  end
end
