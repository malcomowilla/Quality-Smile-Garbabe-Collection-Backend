class AddReceiverToChatMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :chat_messages, :receiver, polymorphic: true, index: true

  end
end
