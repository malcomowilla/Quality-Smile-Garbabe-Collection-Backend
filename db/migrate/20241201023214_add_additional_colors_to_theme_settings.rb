class AddAdditionalColorsToThemeSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :theme_settings, :success, :string
    add_column :theme_settings, :warning, :string
    add_column :theme_settings, :error, :string
  end
end
