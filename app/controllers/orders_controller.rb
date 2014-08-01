class OrdersController < MerchantApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
    respond_to do |format|
      format.html { render layout: "account" }
      format.json { render :json => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json => @order }
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  def bill_code

    bill_code = '{'+'"bill_code":'+'"'+orders_bill_code(params[:warehouse_id])+'"'+'}'

    render json: bill_code
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json

  def create
      param = params[:order]
      bill_code = params[:bill_code]
      delivery_code = params[:delivery]
      selling_stock = param['buy_product_list']
      order_summary = param['order_summary']
    #-----Tạo hóa đơn bán hàng!--->
    #Nhận: Mảng các sản phẩm [stockSummary]
    #1.Tạo hóa đơn mới
    @current_order = Order.new()
    @current_order.branch_id = brach_on_warehouse(order_summary['warehouse_id'])
    @current_order.warehouse_id = order_summary['warehouse_id']
    @current_order.merchant_account_id = order_summary['merchant_account']['id']
    @current_order.customer_id = order_summary['merchant_customer']['id']
    @current_order.name = orders_bill_code(order_summary['warehouse_id'])

    @current_order.return=0
    @current_order.delivery=order_summary['delivery']
    @current_order.payment_method=order_summary['payment_method']
    @current_order.status=0

    @current_order.discount_voucher = order_summary['voucher']
    @current_order.deposit=0
    @current_order.bill_discount = order_summary['bill_discount']
    @current_order.discount_cash = order_summary['discount_cash']
    @current_order.total_price = order_summary['total_price']
    @current_order.final_price = order_summary['final_price']

    @current_order.save

    #2.Kiểm tra trường hợp số lượng không đủ bán [stockSummary] -> trả về lỗi!
    selling_check_quality_before_sale selling_stock

    #3.Bởi vì số lượng là hợp lý, thực hiện bán hàng, trừ số lượng tồn kho=>
    #   Có 2 trường hợp:
    #     Nếu [dilivery=true] thì trừ khả dĩ [available_quality].
    #     Nếu [dilivery=false] thì trừ cả 2 khả dĩ [available_quality] và thực tế [instock_quality]
    #   Bởi vì hàng bán ra thực tế nằm trong bản [stock] không phải [stockSummary] nên, phải *trừ theo đợt
    #   (ví dụ có 2 đợt nhập cùng sản phẩm - và số lượng bán vượt qua một đợt thì sẽ phải trừ cả 2 đợt để cho đủ số sản phẩm)
    selling_stock.each do |item|
    stocking_items = Product.where(product_code: item['product_code'], skull_id:item['skull_id'], warehouse_id: item['warehouse_id']).where('available_quality > ?', 0)
    #Trừ số lượng sản phẩm trong bảng Product
    subtract_quality_on_sale stocking_items, item, @current_order, @current_order.delivery, @current_order.bill_discount
    #4.Cập nhật hóa đơn.
    #   1.Thêm các record vào bảng [OrderDetails] với id của hóa đơn đang tạo! (tức là thêm chi tiết vào cho hóa đơn)
    #   2.Cập nhật các số liệu khác: tổng tiền, giảm giá...
    # @current_order.discount_cash += item['discount_cash']
    # @current_order.total_price += item['price'] * item['sale_quality']
    # @current_order.final_price = @current_order.total_price - (@current_order.deposit + @current_order.discount_cash)
    end
    #Cập nhật và bảng Summary
    metro_summary = MetroSummary.find_by_warehouse_id(@current_order.warehouse_id)
    metro_summary.revenue -= @current_order.discount_cash  if @current_order.delivery == false
    metro_summary.revenue_day -= @current_order.discount_cash if @current_order.delivery == false
    metro_summary.revenue_month -= @current_order.discount_cash if @current_order.delivery == false



    #Tạo phiếu giao hàng
    if @current_order.delivery == true
    @current_order.status = 2
    Delivery.create!(
        :order_id => @current_order.id,
        :merchant_account_id => current_merchant_account.id,
        :success => false,
        :creation_date => @current_order.created_at,
        :delivery_date => @current_order.updated_at,
        :delivery_address => 'Ho Chi Minh',
        :contact_name => 'Sang',
        :contact_phone => '0123456789',
        :transportation_fee => 200,
        :comment => 'Giao Hang Tan Noi',
        :status => 0
    )
    else
      @current_order.status = 1
    end
    #Cập nhật phiếu Order
    @current_order.save
    respond_to do |format|
        format.html { redirect_to @current_order, notice: 'Export detail was successfully created.' }
        format.json { render :json => @current_order, status: :created, location: @current_order }
    end



  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
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

  # DELETE /orders/1
  # DELETE /orders/1.json
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
    def selling_check_quality_before_sale(product_array)
      product_id=[]
      product_array.each { |item| product_id += [item['id']] }
       @Product_Summary = ProductSummary.where(id:product_id.uniq)
      product_array.each { |item|
        if @Product_Summary.find(item['id']).quality < item['sale_quality'] #item.buying_quality
          #TODO: gửi về lỗi chi tiết trên từng sản phẩm, cái nào thiếu bao nhiêu!
          flash.now.alert = 'So luong ton kho hien tai khong du!'
          render 'new'
        end
      }
    end



      #is_delivery_sale == false là bán trực tiếp
    def subtract_quality_on_sale (stocking_items, selling_item, current_order, is_delivery_sale, bill_discount)
      transactioned_quality = 0
      #Tìm Bang Metro_Summary
      metro_summary = MetroSummary.find_by_warehouse_id(@current_order.warehouse_id)
      stocking_items.each do |stock|
        #số lượng còn phải lấy = là số lượng tổng - số lượng đã lấy
        required_quality = selling_item['sale_quality'] - transactioned_quality

        #Nếu như số lượng cần lấy [stock.available_quality] có đủ trong kho,
        #Nếu đợt hàng có đủ s.phẩm thì lấy đúng số lượng cần lấy, không đủ thì lấy hết những gì đang có của đợt sp!
        takken_quality = stock.available_quality > required_quality ? required_quality : stock.available_quality
        if bill_discount == true
          OrderDetail.create!(
              :order_id => current_order.id,
              :product_id => stock.id,
              :name => @current_order.name,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => 0,
              :discount_cash => 0,
              :total_amount => takken_quality * selling_item['price'])
        else
          OrderDetail.create!(
              :order_id => current_order.id,
              :product_id => stock.id,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => selling_item['discount_percent'],
              :discount_cash => (selling_item['discount_percent']*selling_item['price']*takken_quality/100),
              :total_amount => (takken_quality * selling_item['price'])-(selling_item['discount_percent']*selling_item['price']*takken_quality/100))
        end
        #Tạo mới chi tiết đơn hàng với số lượng đã lấy [takken_quality]---------------------------------------------------

        #trừ số lượng khả dĩ và số lượng tồn thực tế!---------------------------------------------------------------------
        stock.available_quality -= takken_quality
        stock.instock_quality -= takken_quality if is_delivery_sale == false
        stock.save()

        #Cong Revenue vào bảng MetroSummary
        if bill_discount == true
          total_amount = (takken_quality * selling_item['price'])
        else
          total_amount = (takken_quality * selling_item['price']) - selling_item['discount_cash']
        end

        metro_summary.revenue += total_amount  if is_delivery_sale == false
        metro_summary.revenue_day += total_amount if is_delivery_sale == false
        metro_summary.revenue_month += total_amount if is_delivery_sale == false

        #Cộng dồn số lượng của đợt trước (nếu có) với số lượng vừa lấy khỏi kho!
        transactioned_quality += takken_quality

        #Nếu như đủ hàng (takken_quality == item['quality']),ngừng lấy thêm từ các record phía sau => kết thúc vòng lặp!
        if transactioned_quality == selling_item['sale_quality'] then break end
      end

      #Cập nhật trừ sản phẩm vào bảng ProductSummary
      stocking_item = @Product_Summary.find(selling_item['id'])
      stocking_item.quality -= selling_item['sale_quality']
      stocking_item.save

      #Chỉ tru so luong khi is_delivery_sale = true
      metro_summary.stock_count -= selling_item['sale_quality'] if is_delivery_sale == false
      metro_summary.sale_count += selling_item['sale_quality'] if is_delivery_sale == false
      metro_summary.sale_count_day += selling_item['sale_quality'] if is_delivery_sale == false
      metro_summary.sale_count_month += selling_item['sale_quality'] if is_delivery_sale == false
      #Cập nhật vào Bảng MetroSummary
      metro_summary.save()

      return transactioned_quality == selling_item['sale_quality']
    end

    def orders_bill_code(warehouse_id)
      branch_id = Branch.find_by_merchant_id(warehouse_id)
      bill_code=''
      Order.where(warehouse_id:warehouse_id).order(name: :desc).first(1).each do |item|
        bill_code = item.name
      end
      if bill_code.length == 15 || bill_code[0..11] == Date.today.strftime("%d/%m/%y")+'-'+("%03d" % branch_id.id)
        a=bill_code[12,3]
        a=a.to_i + 1
        bill_code = Date.today.strftime("%d/%m/%y")+'-'+("%03d" % branch_id.id).to_s+("%03d" % a)
      elsif bill_code[0..8] == Date.today.strftime("%d/%m/%y")
         bill_code = Date.today.strftime("%d/%m/%y")+'-'+("%03d" % branch_id.id).to_s+("%03d" % 1)
      else
        bill_code = Date.today.strftime("%d/%m/%y")+'-'+("%03d" % branch_id.id).to_s+("%03d" % 1)
      end
      return bill_code
    end
end
