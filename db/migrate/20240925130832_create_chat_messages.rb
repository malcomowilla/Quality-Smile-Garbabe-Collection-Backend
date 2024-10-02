class CreateChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_messages do |t|
      t.string :content
      t.datetime :date_time_of_message
      t.string :admin_id

      t.timestamps
    end
  end
end
