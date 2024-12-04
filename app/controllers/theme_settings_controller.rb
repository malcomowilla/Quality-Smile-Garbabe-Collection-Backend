  class ThemeSettingsController < ApplicationController
    # before_action :set_tenant
    before_action :authorize_settings_access!

    # def show
    #   theme_settings = @tenant.theme_setting || create_default_theme
    #   render json: theme_settings
    # end

    # def update
    #   theme_settings = @tenant.theme_setting || @tenant.build_theme_setting
      
    #   if theme_settings.update(theme_settings_params)
    #     render json: theme_settings
    #   else
    #     render json: { errors: theme_settings.errors.full_messages }, status: :unprocessable_entity
    #   end
    # end

def get_theme_settings
theme_settings = ThemeSetting.all
render json: theme_settings

end


def create
  theme_setting = ThemeSetting.first_or_initialize do |ts|
    ts.primary_color = '#1976d2'
    ts.secondary_color = '#dc004e'
    ts.background_color = '#ffffff'
    ts.text_color = '#000000'
    ts.sidebar_color = '#1a237e'
    ts.header_color = '#2196f3'
    ts.accent_color = '#ff4081'
    ts.success = '#4caf50'
    ts.warning = '#ff9800'
    ts.error = '#f44336'
    ts.sidebar_menu_items_background_color_active = '#008000'
  end

  if theme_setting.update(theme_settings_params)
    render json: theme_setting
  else
    render json: { errors: theme_setting.errors.full_messages }, status: :unprocessable_entity
  end
end

    def reset
      theme_settings = @tenant.theme_setting
      
      if theme_settings
        default_theme = ThemeSetting.default_theme
        if theme_settings.update(default_theme)
          render json: theme_settings
        else
          render json: { errors: theme_settings.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: create_default_theme
      end
    end

    private

    def set_tenant
      @tenant = ActsAsTenant.current_tenant
    end

    def authorize_settings_access!
      unless current_user.can_manage_settings? || current_user.role == 'super_administrator'
        render json: { error: 'Unauthorized access' }, status: :unauthorized
      end
    end

    def theme_settings_params
      params.require(:theme_settings).permit(
        :primary_color,
        :secondary_color,
        :background_color,
        :text_color,
        :sidebar_color,
        :header_color,
        :accent_color,
        :success,
        :warning,
        :error,
        :sidebar_menu_items_background_color_active
      )
    end

    def create_default_theme
      @tenant.create_theme_setting!(ThemeSetting.default_theme)
    end
  end

