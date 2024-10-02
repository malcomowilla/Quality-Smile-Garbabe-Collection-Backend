class AdminStatusChannel < ApplicationCable::Channel
 



  def subscribed
    stream_from "admin_status_channel"
  #  current_user.update(online: true)
  #  
   ActionCable.server.broadcast "admin_status_channel", { admin_id: current_user.id, online: true }
 end

 def unsubscribed
  #  current_user.update(online: false)
   ActionCable.server.broadcast "admin_status_channel", { admin_id: current_user.id, online: false }
 end
end
