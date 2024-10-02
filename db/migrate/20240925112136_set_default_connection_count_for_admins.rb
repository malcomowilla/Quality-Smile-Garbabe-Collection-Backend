class SetDefaultConnectionCountForAdmins < ActiveRecord::Migration[7.1]
  def change
    change_column_default :admins, :connection_count, 0

  end
end
