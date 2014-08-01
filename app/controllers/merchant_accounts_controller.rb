class MerchantAccountsController < MerchantApplicationController
  before_action :set_merchant_account, only: [:edit, :update, :destroy]

  def current_sales
    @sales = Merchant.find_branch_sales(current_merchant_account.branch_id)
  end

  def show
    if params[:id] == '0'
      @merchant_account = MerchantAccount.find(@current_account.id)
    else
      @merchant_account = MerchantAccount.find(params[:id])
    end

    if @merchant_account.nil?
      respond_to do |format|
        format.html
        format.json { render json: {}, status: :accepted }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: @merchant_account }
      end
    end
  end

  def new
    @merchant_account = MerchantAccount.new
  end

  def edit
  end

  def create
    @merchant_account = MerchantAccount.new(merchant_account_params)

    respond_to do |format|
      if @merchant_account.save
        format.html { redirect_to @merchant_account, notice: 'Merchant account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @merchant_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @merchant_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @merchant_account.update(merchant_account_params)
        format.html { redirect_to @merchant_account, notice: 'Merchant account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @merchant_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @merchant_account.destroy
    respond_to do |format|
      format.html { redirect_to merchant_accounts_url }
      format.json { head :no_content }
    end
  end

  private

  def set_merchant_account
    @merchant_account = MerchantAccount.find(params[:id])
  end

  def merchant_account_params
    params.require(:merchant_account).permit(:account_id, :merchant_id, :branch_id, :current_warehouse_id, :role_id)
  end
end