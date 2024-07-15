class AddDateAndStatusToSms < ActiveRecord::Migration[7.1]
  def change
    add_column :sms, :date, :datetime
    add_column :sms, :status, :string
  end
end
