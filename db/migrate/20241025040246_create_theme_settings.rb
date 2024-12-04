class CreateThemeSettings < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:theme_settings)
      create_table :theme_settings do |t|
        t.references :account, null: false, foreign_key: true, index: { unique: true }
        t.string :primary_color, null: false
        t.string :secondary_color, null: false
        t.string :background_color, null: false
        t.string :text_color, null: false
        t.string :sidebar_color, null: false
        t.string :header_color, null: false
        t.string :accent_color, null: false

        t.timestamps
      end
    end
  end
end