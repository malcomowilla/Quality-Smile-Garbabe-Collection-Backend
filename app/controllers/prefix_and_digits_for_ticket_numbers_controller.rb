class PrefixAndDigitsForTicketNumbersController < ApplicationController
  before_action :set_prefix_and_digits_for_ticket_number, only: %i[ show edit update destroy ]

  # GET /prefix_and_digits_for_ticket_numbers or /prefix_and_digits_for_ticket_numbers.json
  def index
    @prefix_and_digits_for_ticket_numbers = PrefixAndDigitsForTicketNumber.all
  end

  # GET /prefix_and_digits_for_ticket_numbers/1 or /prefix_and_digits_for_ticket_numbers/1.json
  def show
  end

  # GET /prefix_and_digits_for_ticket_numbers/new
  def new
    @prefix_and_digits_for_ticket_number = PrefixAndDigitsForTicketNumber.new
  end

  # GET /prefix_and_digits_for_ticket_numbers/1/edit
  def edit
  end

  # POST /prefix_and_digits_for_ticket_numbers or /prefix_and_digits_for_ticket_numbers.json
  def create
    @prefix_and_digits_for_ticket_number = PrefixAndDigitsForTicketNumber.new(prefix_and_digits_for_ticket_number_params)

    respond_to do |format|
      if @prefix_and_digits_for_ticket_number.save
        format.html { redirect_to prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number), notice: "Prefix and digits for ticket number was successfully created." }
        format.json { render :show, status: :created, location: @prefix_and_digits_for_ticket_number }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_ticket_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefix_and_digits_for_ticket_numbers/1 or /prefix_and_digits_for_ticket_numbers/1.json
  def update
    respond_to do |format|
      if @prefix_and_digits_for_ticket_number.update(prefix_and_digits_for_ticket_number_params)
        format.html { redirect_to prefix_and_digits_for_ticket_number_url(@prefix_and_digits_for_ticket_number), notice: "Prefix and digits for ticket number was successfully updated." }
        format.json { render :show, status: :ok, location: @prefix_and_digits_for_ticket_number }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digits_for_ticket_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefix_and_digits_for_ticket_numbers/1 or /prefix_and_digits_for_ticket_numbers/1.json
  def destroy
    @prefix_and_digits_for_ticket_number.destroy!

    respond_to do |format|
      format.html { redirect_to prefix_and_digits_for_ticket_numbers_url, notice: "Prefix and digits for ticket number was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefix_and_digits_for_ticket_number
      @prefix_and_digits_for_ticket_number = PrefixAndDigitsForTicketNumber.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prefix_and_digits_for_ticket_number_params
      params.require(:prefix_and_digits_for_ticket_number).permit(:prefix, :minimum_digits)
    end
end
