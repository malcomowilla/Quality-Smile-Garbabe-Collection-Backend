class AddConnectionCountToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :connection_count, :string
  end
end
