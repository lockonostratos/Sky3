class TempOrderDetailsController < ApplicationController
  before_action :set_temp_order_detail, only: [:show, :edit, :update, :destroy]

  def index
    @temp_order_details = TempOrderDetail.where(temp_order_id: params[:temp_order_id])
  end

  def show
  end

  def new
    @temp_order_detail = TempOrderDetail.new
  end

  def edit
  end

  def create
    @temp_order_detail = TempOrderDetail.new(temp_order_detail_params)

    @temp_order = TempOrder.find(temp_order_detail_params[:temp_order_id])
    old_order_detail = TempOrderDetail.find_by_temp_order_id_and_product_summary_id_and_discount_percent(temp_order_detail_params[:temp_order_id],
                                                                                                         temp_order_detail_params[:product_summary_id],
                                                                                                         temp_order_detail_params[:discount_percent])
    if old_order_detail
      @temp_order_detail = old_order_detail
      @temp_order_detail.quality += temp_order_detail_params[:quality]
      @temp_order_detail.total_price = @temp_order_detail.quality * @temp_order_detail.price
      @temp_order_detail.discount_cash = (@temp_order_detail.discount_percent * @temp_order_detail.total_price)/100
      @temp_order_detail.final_price = @temp_order_detail.total_price - @temp_order_detail.discount_cash
    else
      @temp_order_detail = TempOrderDetail.new(temp_order_detail_params)
    end

    respond_to do |format|
      if @temp_order_detail.save
        format.html { redirect_to @temp_order_detail, notice: 'Temp order detail was successfully created.' }
        format.json { render :json => @temp_order_detail, status: :created, location: @temp_order_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @temp_order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @temp_order_detail.update(temp_order_detail_params)
        format.html { redirect_to @temp_order_detail, notice: 'Temp order detail was successfully updated.' }
        format.json { render :json => @temp_order_detail}
      else
        format.html { render action: 'edit' }
        format.json { render json: @temp_order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @temp_order_detail.destroy
    respond_to do |format|
      format.html { redirect_to temp_order_details_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp_order_detail
      @temp_order_detail = TempOrderDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def temp_order_detail_params
      params.require(:temp_order_detail).permit(:temp_order_id, :product_summary_id, :name, :product_code, :skull_id, :warehouse_id, :quality, :price, :discount_cash, :discount_percent, :temp_discount_percent, :total_price, :final_price)
    end
end

