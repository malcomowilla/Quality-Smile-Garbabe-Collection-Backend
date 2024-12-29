class RemoveSentAtFromDevices < ActiveRecord::Migration[7.1]
  def change
    remove_column :devices, :device_verification_token_sent_at, :boolean
  end
end
