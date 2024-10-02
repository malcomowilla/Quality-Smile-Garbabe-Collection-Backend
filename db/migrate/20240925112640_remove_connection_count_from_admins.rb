class RemoveConnectionCountFromAdmins < ActiveRecord::Migration[7.1]
  def change
    remove_column :admins, :connection_count, :string
  end
end
