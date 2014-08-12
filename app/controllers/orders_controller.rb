class OrdersController < MerchantApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def bill_code
    bill_code = '{'+'"bill_code":'+'"'+orders_bill_code(params[:warehouse_id])+'"'+'}'
    render json: bill_code
  end

  def edit
  end

  def search
    warehouse_id = if params[:warehouse_id] then params[:warehouse_id] else current_merchant_account.current_warehouse_id end
    if params[:seller_id]
      @orders = Order.where(warehouse_id: warehouse_id, merchant_account_id: params[:seller_id])
    else
      @orders = Order.where(warehouse_id: warehouse_id)
    end
  end

  def create_failed
  end

  def check_quality_before_sale(items) #product_summary
    sum_product_quality = items.group(:product_summary_id).sum(:quality) #lấy id , số lương {"1"=>10,"3"=>15}
    group_product_id = items.pluck(:product_summary_id).uniq #lấy id từ mảng [1,3]
    group_product_id.each do |item|
      product_summary =  ProductSummary.find(item)
      if product_summary.quality < sum_product_quality[item] #thất bại dẫn tới create_failed
        @a = 1
        respond_to do |format|
          format.html { redirect_to orders_url }
          format.json { render json: @a }
        end
        break
      end
    end
  end

  def check_delivery
    delivery = params[:order]['temp_delivery']
    delivery.delivery_date #phải lớn hơn ngày hiện tại, theo chuẩn

  end


=begin
    Pseudo
    Kiểm tra phiếu có tồn tại?
    Kiểm tra phiếu đó có chi tiết? (danh sách hàng bán)
    Kiểm tra có đủ hàng để bán?
    Kiểm tra thông tin giao hàng (nếu có)
    -----An toàn--------->
    Thực hiện khởi tạo Order!
=end
  def create
    temp_order = TempOrder.find(params[:order]['temp_order_id']); if !temp_order then create_failed end
    selling_items = temp_order.details; if selling_items.length <= 0 then create_failed end
    check_quality_before_sale(selling_items)
    # if temp_order.delivery == 1 check_delivery
    
    newOrder = temp_order.clone_to_order()
    selling_items.each do |product|
      stocking_items = Product.where(product_code: product['product_code'], skull_id: product['skull_id'], warehouse_id: product['warehouse_id']).where('available_quality > ?', 0)
      subtract_quality_on_sales stocking_items, product, newOrder
    end
    newOrder.update_metro_summary()
    if newOrder.delivery == 0 then newOrder.status = Order.statuses[:finish] end
    if newOrder.delivery == 1 then newOrder.status = Order.statuses[:delivery]; create_new_delivery(newOrder, params[:order]['temp_delivery']) end
    newOrder.save()
    #Xóa sản phẩm trong bảng tạm
    # temp_order.destroy
    # selling_stock.each do |item|
    #   item.destroy
    # end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:order_summary, :branch_id, :warehouse_id, :merchant_account_id, :name, :customer_id, :return, :delivery, :total_price, :deposit, :discount_cash, :final_price, :payment_method, :status)
    end

    #Kiểm tra số lượng tồn kho so vớ số lượng bán, trên bảng ProductSummary

    #selling_item trong bảng temp_order_detail
    #stocking_items trong bảng Product
    def subtract_quality_on_sales (stocking_items, selling_item , newOrder)
      transactioned_quality = 0
      stocking_items.each do |product|
        required_quality = selling_item['quality'] - transactioned_quality
        takken_quality = product.available_quality > required_quality ? required_quality : product.available_quality
        #xử lý giảm giá(theo tong bill hay từng sản phẩm)
        if newOrder.bill_discount
          total_price = (takken_quality * selling_item['price'])
          discount_percent = newOrder.discount_cash/(newOrder.total_price/100)
          discount_cash = (discount_percent * total_price)/100
          order_detail = OrderDetail.create!(
              :order_id => newOrder.id,
              :product_id => product.id,
              :name => newOrder.name,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => discount_percent,
              :discount_cash => discount_cash,
              :final_price => total_price - discount_cash
          )
        else
          order_detail = OrderDetail.create!(
              :order_id => newOrder.id,
              :product_id => product.id,
              :name => newOrder.name,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => selling_item['discount_percent'],
              :discount_cash => (selling_item['discount_percent'] * (takken_quality * selling_item['price'])/100),
              :final_price => (takken_quality * selling_item['price']) - (selling_item['discount_percent'] * (takken_quality * selling_item['price'])/100)
          )
        end
        if newOrder.delivery == 0
          order_detail.status = Order.statuses[:finish]
        elsif newOrder.delivery == 1
          order_detail.status = Order.statuses[:delivery]
        end
        order_detail.save()

        #Trừ sản phẩm vào bảng Product(ko trừ nếu có giao hàng)
        product.available_quality -= takken_quality
        product.instock_quality -= takken_quality if newOrder.delivery == 0
        product.save()
        transactioned_quality += takken_quality
        if transactioned_quality == selling_item['quality'] then break end
      end
      return transactioned_quality == selling_item['quality']
    end

    def create_new_delivery(order, delivery)
    Delivery.create!(
        :warehouse_id =>order.warehouse_id,
        :order_id => order.id,
        :merchant_account_id => order.creator_id,
        :name => order.name,
        :creation_date => order.created_at,
        :delivery_date => delivery['delivery_date'],
        :delivery_address => delivery['delivery_address'],
        :contact_name => delivery['contact_name'],
        :contact_phone => delivery['contact_phone'],
        :transportation_fee => delivery['transportation_fee'],
        :comment => delivery['comment'],
        :status => :initializing
    )
  end
end
