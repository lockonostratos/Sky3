class TempOrdersController < MerchantApplicationController
  before_action :set_temp_order, only: [:show, :edit, :update, :destroy]

  def index
    warehouse_id = if params[:warehouse_id] then params[:warehouse_id] else current_merchant_account.current_warehouse_id end
    creator_id = if params[:creator_id] then params[:creator_id] else current_merchant_account.account_id end
    @temp_orders = TempOrder.where(warehouse_id: warehouse_id, creator_id: creator_id)
  end

  def show
  end

  # GET /temp_orders/new
  def new
    @temp_order = TempOrder.new
    respond_to do |format|
      format.html { render layout: "account" }
      format.json { render :json => @temp_order, root: false }
    end
  end

  # GET /temp_orders/1/edit
  def edit
  end

  # POST /temp_orders
  # POST /temp_orders.json
  def create
    @temp_order = TempOrder.new(temp_order_params)

    respond_to do |format|
      if @temp_order.save
        format.html { redirect_to @temp_order, notice: 'Temp order was successfully created.' }
        format.json { render json: @temp_order, root: false, action: 'show', status: :created, location: @temp_order }
      else
        format.html { render json: @temp_order, root: false }
        format.json { render json: @temp_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @temp_order.update(temp_order_params)
        format.html { redirect_to @temp_order, notice: 'Temp order was successfully updated.' }
        format.json { render json: @temp_order }
      else
        format.html { render action: 'edit' }
        format.json { render json: @temp_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temp_orders/1
  # DELETE /temp_orders/1.json
  def destroy
    @temp_order.destroy
    respond_to do |format|
      format.html { redirect_to temp_orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp_order
      @temp_order = TempOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def temp_order_params
      params.require(:temp_order).permit(:branch_id, :warehouse_id, :seller_id, :buyer_id, :creator_id, :name, :return, :payment_method, :delivery, :bill_discount, :total_price, :discount_voucher, :discount_cash, :final_price, :deposit, :currency_debit)
    end
end
