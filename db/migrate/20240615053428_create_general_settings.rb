class CreateGeneralSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :general_settings do |t|

      t.timestamps
    end
  end
end
