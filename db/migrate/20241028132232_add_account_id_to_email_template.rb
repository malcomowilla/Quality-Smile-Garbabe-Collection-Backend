class AddAccountIdToEmailTemplate < ActiveRecord::Migration[7.1]
  def change
    add_column :email_templates, :account_id, :integer
  end
end
