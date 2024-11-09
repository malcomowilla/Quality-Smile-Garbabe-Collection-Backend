class AddToChatMessages < ActiveRecord::Migration[7.1]
  def change
    # Add sender_type if it doesn't exist
    unless column_exists?(:chat_messages, :sender_type)
      add_column :chat_messages, :sender_type, :string
    end
    
    # Update existing records (assuming they're all from customers)
    execute <<-SQL
      UPDATE chat_messages 
      SET sender_type = 'Customer'
      WHERE sender_type IS NULL
    SQL
    
    # Add the null constraints
    change_column_null :chat_messages, :sender_type, false
    change_column_null :chat_messages, :sender_id, false
    
    # Add the polymorphic index if it doesn't exist
    unless index_exists?(:chat_messages, [:sender_type, :sender_id])
      add_index :chat_messages, [:sender_type, :sender_id]
    end
  end
end
