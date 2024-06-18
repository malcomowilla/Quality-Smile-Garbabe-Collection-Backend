class ApplicationController < ActionController::Base

    include ActionController::Cookies
    # protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token



  
# def current_user
#     # render json: { user: UserSerializer.new(current_user) }, status: :accepted
#     @admin = Admin.find_by(id:session[:admin_id])
      
    
              
#     end

end
