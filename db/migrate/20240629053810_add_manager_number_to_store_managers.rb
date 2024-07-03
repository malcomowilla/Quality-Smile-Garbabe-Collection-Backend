class AddManagerNumberToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :manager_number, :string
  end
end
