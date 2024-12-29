class AddDeviceNameToDevice < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :device_name, :string
  end
end
