class AddToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chat_rooms, :customer, null: false, foreign_key: true
    add_reference :chat_rooms, :admin, null: false, foreign_key: true
    add_index :chat_rooms, [:customer_id, :admin_id], unique: true
  end
end
