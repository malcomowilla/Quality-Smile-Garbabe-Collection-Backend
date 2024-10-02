class AddConnectionCountsToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :connection_count, :integer
  end
end
