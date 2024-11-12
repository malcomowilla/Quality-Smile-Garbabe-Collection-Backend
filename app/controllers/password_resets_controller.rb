class PasswordResetsController < ApplicationController



    before_action :set_tenant 
    set_current_tenant_through_filter
  
       
  
  
  
    def set_tenant
      @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])
    
      set_current_tenant(@account)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Invalid tenant' }, status: :not_found
    end


def create
    @admin = Admin.find_by(email: params[:email]) || Admin.find_by(phone_number: params[:phone_number])

    
end





end
