class PresenceChannel < ApplicationCable::Channel
  HEARTBEAT_INTERVAL = 30 # seconds
  OFFLINE_THRESHOLD = 45 # seconds




  def subscribed
    stream_from "presence_channel"
    current_user.update(
      online: true,
      last_heartbeat: Time.current
    )
    broadcast_status
    start_heartbeat_check
  end

  def unsubscribed
    current_user.update(
      online: false,
      last_seen: Time.current
    )
    broadcast_status
  end


  def heartbeat
    current_user.update(last_heartbeat: Time.current)
    broadcast_status
  end

  private

  def start_heartbeat_check
    Thread.new do
      while connection.present?
        sleep HEARTBEAT_INTERVAL
        if Time.current - current_user.last_heartbeat > OFFLINE_THRESHOLD.seconds
          current_user.update(online: false, last_seen: current_user.last_heartbeat)
          broadcast_status
          break
        end
      end
    end
  end


  def broadcast_status
    ActionCable.server.broadcast "presence_channel", {
      user_id: current_user.id,
      online: current_user.online,
      last_seen: format_last_seen(current_user.last_seen),
      user_name: current_user.user_name,
      status_message: generate_status_message,
      connection_type: connection.env['HTTP_X_FORWARDED_FOR'] ? 'web' : 'mobile'
    }
  end

  def format_last_seen(timestamp)
    return nil unless timestamp.present?

    if timestamp.today?
      timestamp.strftime('Today at %I:%M %p')
    elsif timestamp.yesterday?
      timestamp.strftime('Yesterday at %I:%M %p')
    else
      timestamp.strftime('%B %d at %I:%M %p')
    end
  end

  def generate_status_message
    if current_user.online
      'Online'
    elsif current_user.last_seen.present?
      time_ago = TimeDifference.between(current_user.last_seen, Time.current).in_general
      "Last seen #{time_ago}"
    else
      'Offline'
    end
  end
end





