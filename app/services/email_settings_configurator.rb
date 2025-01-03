class EmailSettingsConfigurator
    def self.configure(current_account)
      current_account =  current_account 
      if current_account.nil?
        Rails.logger.warn "No current account found. Using fallback email settings."
        set_fallback_settings
      else
        configure_for_account(current_account)
      end
    rescue StandardError => e
      Rails.logger.error "Error configuring email settings: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  
    private
  
    def self.configure_for_account(account)
      email_setting = account.email_setting
  
      if email_setting&.api_key.present?
        Rails.logger.info "Configuring Mailtrap with API Key"
        Rails.application.config.action_mailer.delivery_method = :mailtrap
        Rails.application.config.action_mailer.mailtrap_settings = {
          api_key: email_setting.api_key
        }
      elsif email_setting.present?
        Rails.logger.info "Configuring SMTP with Email Settings"
        Rails.application.config.action_mailer.delivery_method = :smtp
        Rails.application.config.action_mailer.smtp_settings = {
          user_name: email_setting.smtp_username,
          password: email_setting.smtp_password,
          address: email_setting.smtp_host,
          domain: email_setting.domain,
          port: '587',
          authentication: :plain,
          enable_starttls_auto: true
        }
      else
        Rails.logger.warn "No email settings found for account. Using fallback."
        set_fallback_settings
      end
    end
  
    def self.set_fallback_settings
      Rails.application.config.action_mailer.delivery_method = :mailtrap
      Rails.application.config.action_mailer.mailtrap_settings = {
        api_key: "f17620673c51e537ef268dea49025da8"
      }
    end
  end
  