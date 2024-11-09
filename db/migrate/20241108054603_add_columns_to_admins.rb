class AddColumnsToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :conversations_count, :integer, default: 0
  
  end
end
