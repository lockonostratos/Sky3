class DeliveriesController < MerchantApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  def index
    @deliveries = Delivery.where(order_id: all_order_on_merchant(current_merchant_account.merchant_id))
  end

  def deliveries_of
    warehouse_id = if params[:warehouse_id] then params[:warehouse_id] else current_merchant_account.current_warehouse_id end
    if params[:merchant_account_id]
      @deliveries = Delivery.where(warehouse_id: warehouse_id, merchant_account_id: params[:merchant_account_id])
    else
      @deliveries = Delivery.where(warehouse_id: warehouse_id)
    end
  end

  def show
  end

  def new
    @delivery = Delivery.new
  end

  def edit
  end

  def create
    @delivery = Delivery.new(delivery_params)
    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'Delivery was successfully created.' }
        format.json { render action: 'show', status: :created, location: @delivery }
      else
        format.html { render action: 'new' }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @delivery = Delivery.find(delivery_params[:id])
    if @delivery and delivery_params[:status] == 1 and @delivery.status == 'initializing'
      @delivery.status = 1
      @delivery.shipper = delivery_params[:shipper]
      @delivery.delivery_date_shipper = Time.now
      @delivery.save()
    elsif @delivery and delivery_params[:status] == 2 and @delivery.status == 'delivery'
      @delivery.status = 2
      @delivery.delivery_date_transport = Time.now
      @delivery.save()
    elsif @delivery and delivery_params[:status] == 3 and @delivery.status == 'delivering'
      @delivery.status = 3
      @delivery.delivery_date_finish = Time.now
      @delivery.save()
      order = @delivery.order
      order.status = 1
      order.save()
    elsif @delivery and delivery_params[:status] == 4 and @delivery.status == 'delivering'
      @delivery.status = 4
      @delivery.delivery_date_finish = Time.now
      @delivery.save()
      order = @delivery.order
      order.status = 3
      order.save()
    end


    # respond_to do |format|
    #   if delivery.success == true || delivery.status != 0 || @delivery.status == 0
    #     format.html { redirect_to @delivery, notice: 'Ko the success' }
    #     format.json { head :no_content }
    #     return
    #   else
    #     if @delivery.status == 1
    #       order = Order.find(@delivery.order_id)
    #       order_detail = OrderDetail.where(order_id:order.id)
    #       products = Product.where(id:order_detail.pluck(:product_id))
    #
    #       #Cap nhat stock_count, sale_count, sale_count_day, sale_count_month vao MetroSummary
    #       metro_summary = MetroSummary.find_by_warehouse_id(order.warehouse_id)
    #       order_detail.each do |order|
    #         product = products.find(order.product_id.to_param)
    #         product.instock_quality = product.instock_quality - order.quality
    #         product.save()
    #         #Cong san pham vao bang MetroSummary
    #         metro_summary.stock_count -= order.quality
    #         metro_summary.sale_count += order.quality
    #         metro_summary.sale_count_day += order.quality
    #         metro_summary.sale_count_month += order.quality
    #       end
    #       metro_summary.revenue += order.final_price
    #       metro_summary.revenue_day += order.final_price
    #       metro_summary.revenue_month += order.final_price
    #       # Cap Nhat Bang MetroSummary
    #       metro_summary.save()
    #       #Cap nhat order
    #       order.status = 3
    #       order.save
    #       @delivery.save()
    #     elsif @delivery.status == 2
    #       order = Order.find(@delivery.order_id)
    #       order_detail = OrderDetail.where(order_id:order.id)
    #       products = Product.where(id:order_detail.pluck(:product_id))
    #       order_detail.each do |order|
    #         product = products.find(order.product_id.to_param)
    #         product.available_quality = product.available_quality + order.quality
    #         products_summaries = ProductSummary.find_by_product_code_and_skull_id_and_warehouse_id(product.product_code, product.skull_id, product.warehouse_id)
    #         products_summaries.quality = products_summaries.quality + order.quality
    #         product.save()
    #         products_summaries.save()
    #       end
    #       order.status = 4
    #       order.save
    #       @delivery.save()
    #   end
    #
    #
    #   end
    #   format.html { redirect_to @delivery, notice: 'ok' }
    #   format.json { head :no_content }
    # end
  end


  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery)
    end
end
