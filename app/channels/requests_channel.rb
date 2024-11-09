class RequestsChannel < ApplicationCable::Channel
  def subscribed

    stream_from "requests_channel"

    
  end

  def unsubscribed
    
  end
end