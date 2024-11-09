class CreateCompanySettings < ActiveRecord::Migration[7.1]
  def change
    create_table :company_settings do |t|
      t.string :company_name
      t.string :contact_info
      t.string :email_info

      t.timestamps
    end
  end
end
