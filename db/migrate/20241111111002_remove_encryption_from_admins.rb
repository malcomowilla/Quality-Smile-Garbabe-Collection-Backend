class RemoveEncryptionFromAdmins < ActiveRecord::Migration[7.1]
   # Store the original data temporarily
  #  remove_column :admins, :email,  :string
  #  remove_column :admins, :fcm_token, :string

  #  remove_column :admins, :email, :string
    
   # Add back unencrypted email column
   add_column :admins, :email, :string
  #  add_column :admins, :email, :string
   add_column :admins, :fcm_token, :string
end
