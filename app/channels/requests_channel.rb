class RequestsChannel < ApplicationCable::Channel
  def subscribed
    ActsAsTenant.with_tenant(current_user.account) do

    stream_from "requests_channel"

    end
  end

  def unsubscribed
    
  end
end