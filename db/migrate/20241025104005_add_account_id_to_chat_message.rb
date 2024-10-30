class AddAccountIdToChatMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_messages, :account_id, :integer
  end
end
