class AddDeviceFingerPrintToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :device_fingerprint, :string
  end
end
