class TypingChannel < ApplicationCable::Channel
  


def subscribed
  @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain)
  ActsAsTenant.with_tenant(@account) do

  stream_from "typing_channel"
  
  end
end


def typing(data)
  # Broadcast typing event with user info
 
  ActionCable.server.broadcast("typing_channel",
   data)

     
end



def stop_typing
 
  # Broadcast a stop typing event (you can send `nil` or just a simple message)
  ActionCable.server.broadcast("typing_channel", {admin: nil})

end



def unsubscribed
    
end

end

