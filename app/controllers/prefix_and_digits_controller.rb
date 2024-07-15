class PrefixAndDigitsController < ApplicationController
  # GET /prefix_and_digits or /prefix_and_digits.json
  def index
    @prefix_and_digits = PrefixAndDigit.all
  end

  # GET /prefix_and_digits/1 or /prefix_and_digits/1.json
  def show
  end

  # GET /prefix_and_digits/new
  def new
    @prefix_and_digit = PrefixAndDigit.new
  end

  # GET /prefix_and_digits/1/edit
  def edit
  end

  # POST /prefix_and_digits or /prefix_and_digits.json
  def create
    @prefix_and_digit = PrefixAndDigit.new(prefix_and_digit_params)

    respond_to do |format|
      if @prefix_and_digit.save
        format.html { redirect_to prefix_and_digit_url(@prefix_and_digit), notice: "Prefix and digit was successfully created." }
        format.json { render :show, status: :created, location: @prefix_and_digit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prefix_and_digits/1 or /prefix_and_digits/1.json
  def update
    respond_to do |format|
      if @prefix_and_digit.update(prefix_and_digit_params)
        format.html { redirect_to prefix_and_digit_url(@prefix_and_digit), notice: "Prefix and digit was successfully updated." }
        format.json { render :show, status: :ok, location: @prefix_and_digit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix_and_digit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prefix_and_digits/1 or /prefix_and_digits/1.json
  def destroy
    @prefix_and_digit.destroy!

    respond_to do |format|
      format.html { redirect_to prefix_and_digits_url, notice: "Prefix and digit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prefix_and_digit
      @prefix_and_digit = PrefixAndDigit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prefix_and_digit_params
      params.require(:prefix_and_digit).permit(:prefix, :minimum_digits)
    end
end
