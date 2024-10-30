class TypingChannel < ApplicationCable::Channel
  


def subscribed
  ActsAsTenant.with_tenant(current_user.account) do

  stream_from "typing_channel"
  
  end
end


def typing(data)
  # Broadcast typing event with user info
ActsAsTenant.with_tenant(current_user.account) do
  ActionCable.server.broadcast("typing_channel",
   data)

     end 
end



def stop_typing
  ActsAsTenant.with_tenant(current_user.account) do
  # Broadcast a stop typing event (you can send `nil` or just a simple message)
  ActionCable.server.broadcast("typing_channel", {admin: nil})
end
end



def unsubscribed
    
end

end

