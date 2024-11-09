class AddToConversations < ActiveRecord::Migration[7.1]
  def change
    add_reference :conversations, :customer, null: false, foreign_key: true
    add_reference :conversations, :admin, null: false, foreign_key: true
    add_column :conversations, :status, :string, default: 'active'
    add_column :conversations, :messages_count, :integer, default: 0
    add_column :conversations, :last_message_at, :datetime
    add_reference :conversations, :account, null: false, foreign_key: true
    add_index :conversations, [:customer_id, :admin_id], unique: true
    

    # Index for finding active conversations
    add_index :conversations, :status
  end
end
