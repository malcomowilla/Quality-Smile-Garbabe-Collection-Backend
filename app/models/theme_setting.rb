class ThemeSetting < ApplicationRecord

  acts_as_tenant(:account)


  validates :account_id, presence: true
  validates :primary_color, presence: true
  validates :secondary_color, presence: true
  validates :background_color, presence: true
  validates :text_color, presence: true
  validates :sidebar_color, presence: true
  validates :header_color, presence: true
  validates :accent_color, presence: true
  validates :sidebar_menu_items_background_color_active, presence: true

  # Default theme colors
  def self.default_theme
    {
      primary_color: '#1976d2',
      secondary_color: '#dc004e',
      background_color: '#ffffff',
      text_color: '#000000',
      sidebar_color: '#1a237e',
      header_color: '#f5f5f5',
      accent_color: '#2196f3',
      sidebar_menu_items_background_color_active: '#008000',
    }
  end
end
