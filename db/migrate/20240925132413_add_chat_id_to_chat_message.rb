class AddChatIdToChatMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :chat_room_id, :integer
  end
end
