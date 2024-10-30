Rails.application.config.after_initialize do
  api_key = EmailSetting.first&.api_key
  domain = EmailSetting.first&.domain
  smtp_host = EmailSetting.first&.smtp_host
  smtp_username = EmailSetting.first&.smtp_username
  smtp_password = EmailSetting.first&.smtp_password
  
  # Rails.application.config.action_mailer.
  # mailtrap_settings = { api_key: api_key } if api_key

if api_key 
  Rails.application.config.action_mailer.mailtrap_settings={
    api_key: api_key
  }
else
  config.action_mailer.smtp_settings={
     :user_name => smtp_username,
  :password => smtp_password,
  :address => smtp_host,
  :domain => domain,
  :port => '587',
  :authentication => :plain,

  :enable_starttls_auto => true 
  }
end

end

