class AddNamePhoneNumberAndEmailStoreNumberToStoreManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :store_managers, :name, :string
    add_column :store_managers, :email, :string
    add_column :store_managers, :phone_number, :string
    add_column :store_managers, :store_number, :string
  end
end
