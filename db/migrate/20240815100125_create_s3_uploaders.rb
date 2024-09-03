class CreateS3Uploaders < ActiveRecord::Migration[7.1]
  def change
    create_table :s3_uploaders do |t|
      t.string :region
      t.string :access_key_id
      t.string :secret_access_key

      t.timestamps
    end
  end
end
