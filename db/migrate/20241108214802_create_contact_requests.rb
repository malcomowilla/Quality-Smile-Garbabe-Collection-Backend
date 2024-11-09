class CreateContactRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_requests do |t|
      t.string :company_name
      t.string :business_type
      t.string :contact_person
      t.string :business_email
      t.string :phone_number
      t.string :expected_users

      t.timestamps
    end
  end
end
