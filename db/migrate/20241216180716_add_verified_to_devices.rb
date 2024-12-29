class AddVerifiedToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :verified, :boolean
  end
end
