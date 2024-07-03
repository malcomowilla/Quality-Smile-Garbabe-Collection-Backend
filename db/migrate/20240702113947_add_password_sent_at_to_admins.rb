class AddPasswordSentAtToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :reset_password_sent_at, :datetime
  end
end
