class AddSentAtToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :device_verification_token_sent_at, :datetime
  end
end
