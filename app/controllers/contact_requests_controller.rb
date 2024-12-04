class ContactRequestsController < ApplicationController
  before_action :set_contact_request, only: %i[ show edit update destroy ]

  # GET /contact_requests or /contact_requests.json
  def index
    @contact_requests = ContactRequest.all
  end


  def create
    @contact_request = ContactRequest.new(contact_request_params)

    if @contact_request.save
      render json: { message: 'Request submitted successfully' }, status: :created
    else
      render json: { errors: @contact_request.errors.full_messages }, 
        status: :unprocessable_entity
    end
  end


  # DELETE /contact_requests/1 or /contact_requests/1.json
  def destroy
    @contact_request.destroy!

    respond_to do |format|
      format.html { redirect_to contact_requests_url, notice: "Contact request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_request
      @contact_request = ContactRequest.find(params[:id])
    end



    def contact_request_params
      params.require(:contact_request).permit(
        :company_name, :business_type, :contact_person, 
        :business_email, :phone_number, :expected_users,
        :country, :city, :message, :company_website
      )
    end


   
end
