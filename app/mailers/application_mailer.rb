class ApplicationMailer < ActionMailer::Base
  # default from: "from@example.com"
  # default from: "info@aitechsent.net"
  # 
  sender_email = EmailSetting.first.sender_email
  default from: sender_email 

  # layout "mailer"
end





