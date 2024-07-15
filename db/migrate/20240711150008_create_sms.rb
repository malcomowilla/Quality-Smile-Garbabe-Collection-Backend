class CreateSms < ActiveRecord::Migration[7.1]
  def change
    create_table :sms do |t|
      t.string :user
      t.string :message

      t.timestamps
    end
  end
end
