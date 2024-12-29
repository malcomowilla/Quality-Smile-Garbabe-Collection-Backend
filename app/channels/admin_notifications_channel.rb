class AdminNotificationsChannel < ApplicationCable::Channel
  def subscribed
    # For admins: they see conversations they're assigned to
    stream_from "admin_notifications"
  end

  def unsubscribed  
    stop_all_streams
  end
end