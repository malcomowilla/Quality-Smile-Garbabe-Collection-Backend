class AddConversationIdToChatMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :chat_messages, :conversation, foreign_key: true

  end
end
