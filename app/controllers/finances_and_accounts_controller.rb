class FinancesAndAccountsController < ApplicationController
  before_action :set_finances_and_account, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  
  
  
  before_action :set_tenant 
  set_current_tenant_through_filter

     



  def set_tenant
    @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])
  
    set_current_tenant(@account)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid tenant' }, status: :not_found
  end
  
  #finances_and_accounts or /finances_and_accounts.json
  def index
    @finances_and_accounts = FinancesAndAccount.all
  end

  # GET /finances_and_accounts/1 or /finances_and_accounts/1.json
  def show
  end

  # GET /finances_and_accounts/new
  def new
    @finances_and_account = FinancesAndAccount.new
  end

  # GET /finances_and_accounts/1/edit
  def edit
  end

  # POST /finances_and_accounts or /finances_and_accounts.json
  def create
    @finances_and_account = FinancesAndAccount.new(finances_and_account_params)

    respond_to do |format|
      if @finances_and_account.save
        format.html { redirect_to finances_and_account_url(@finances_and_account), notice: "Finances and account was successfully created." }
        format.json { render :show, status: :created, location: @finances_and_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @finances_and_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances_and_accounts/1 or /finances_and_accounts/1.json
  def update
    respond_to do |format|
      if @finances_and_account.update(finances_and_account_params)
        format.html { redirect_to finances_and_account_url(@finances_and_account), notice: "Finances and account was successfully updated." }
        format.json { render :show, status: :ok, location: @finances_and_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @finances_and_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances_and_accounts/1 or /finances_and_accounts/1.json
  def destroy
    @finances_and_account.destroy!

    respond_to do |format|
      format.html { redirect_to finances_and_accounts_url, notice: "Finances and account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finances_and_account
      @finances_and_account = FinancesAndAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def finances_and_account_params
      params.require(:finances_and_account).permit(:category, :name, :description, :date, :reference)
    end
end
