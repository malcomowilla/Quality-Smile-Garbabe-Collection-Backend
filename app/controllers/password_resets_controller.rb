class PasswordResetsController < ApplicationController





def create
    @admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])

    
end





end
