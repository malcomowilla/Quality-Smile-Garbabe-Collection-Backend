class AddSidebarMenuItemsThemeToThemeSettings < ActiveRecord::Migration[7.1]
  def up
    # First add the column as nullable
    add_column :theme_settings, :sidebar_menu_items_background_color_active, :string

    # Set a default value for existing records
    execute "UPDATE theme_settings SET sidebar_menu_items_background_color_active = '#E5E7EB'"

    # Then make it non-nullable
    change_column_null :theme_settings, :sidebar_menu_items_background_color_active, false
  end
end