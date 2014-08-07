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
    temp_order = TempOrder.find(params[:order]['temp_order_id'])
    if temp_order
      selling_stock = temp_order.details
      if selling_stock
        @current_order = Order.create!( branch_id: temp_order.branch_id,
                                        warehouse_id: temp_order.warehouse_id,
                                        creator_id: temp_order.creator_id,
                                        seller_id: temp_order.seller_id,
                                        buyer_id: temp_order.buyer_id,
                                        name: orders_bill_code(temp_order.warehouse_id),
                                        status: :initialized,
                                        delivery: temp_order.delivery,
                                        payment_method: temp_order.payment_method,
                                        bill_discount: temp_order.bill_discount,
                                        deposit: temp_order.deposit,
                                        debt: 0,
                                        discount_voucher: temp_order.discount_voucher,
                                        discount_cash: temp_order.discount_cash,
                                        total_price: temp_order.total_price,
                                        final_price: temp_order.final_price )
        selling_stock.each do |product|
          stocking_items = Product.where(product_code: product['product_code'], skull_id: product['skull_id'], warehouse_id: product['warehouse_id']).where('available_quality > ?', 0)
          subtract_quality_on_sales stocking_items, product
        end
        #Tìm Bang Metro_Summary
        metro_summary = MetroSummary.find_by_warehouse_id(@current_order.warehouse_id)
        #Cộng tiền vào bảng Metro Summary
        metro_summary.revenue += @current_order.final_price  if @current_order.delivery == 0
        metro_summary.revenue_day += @current_order.final_price if @current_order.delivery == 0
        metro_summary.revenue_month += @current_order.final_price if @current_order.delivery == 0
        metro_summary.save()
        #Tạo phiếu giao hàng
        if @current_order.delivery
          Delivery.create!(
                  :order_id => @current_order.id,
                  :merchant_account_id => @current_order.creator_id,
                  :name => @current_order.name,
                  :creation_date => @current_order.created_at,
                  :delivery_date => @current_order.updated_at,
                  :delivery_address => 'Ho Chi Minh',
                  :contact_name => 'Sang',
                  :contact_phone => '0123456789',
                  :transportation_fee => 200,
                  :comment => 'Giao Hang Tan Noi',
                  :status => 0
              )
        end

        #Cập nhật trang thái order
        if @current_order.delivery == 0
          @current_order.status = Order.statuses[:finish]
        elsif @current_order.delivery == 1
          @current_order.status = Order.statuses[:delivery]
        end
        @current_order.save()
        @current_order.branch
        Transaction.create(type:1)

        # (merchant_id: 1,
        #     branch_id: 1,
        #     warehouse_id:1,
        #     type: 1,
        #     parent_id: 1,
        #     creator_id: 1,
        #     owner_id: 1,
        #     receivable: 1,
        # status: 1

        #Xóa sản phẩm trong bảng tạm
        # temp_order.destroy
        # selling_stock.each do |item|
        #   item.destroy
        # end

      end
    end
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
    #selling_item trong bảng temp_order_detail
    #stocking_items trong bảng Product
    def subtract_quality_on_sales (stocking_items, selling_item)
      transactioned_quality = 0
      stocking_items.each do |product|
        required_quality = selling_item['quality'] - transactioned_quality
        takken_quality = product.available_quality > required_quality ? required_quality : product.available_quality
        #xử lý giảm giá(theo tong bill hay từng sản phẩm)
        if @current_order.bill_discount
          total_price = (takken_quality * selling_item['price'])
          discount_percent = @current_order.discount_cash/(@current_order.total_price/100)
          discount_cash = (discount_percent * total_price)/100
          order_detail = OrderDetail.create!(
              :order_id => @current_order.id,
              :product_id => product.id,
              :name => @current_order.name,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => discount_percent,
              :discount_cash => discount_cash,
              :final_price => total_price - discount_cash
          )
        else
          order_detail = OrderDetail.create!(
              :order_id => @current_order.id,
              :product_id => product.id,
              :name => @current_order.name,
              :quality => takken_quality,
              :price => selling_item['price'],
              :discount_percent => selling_item['discount_percent'],
              :discount_cash => (selling_item['discount_percent'] * (takken_quality * selling_item['price'])/100),
              :final_price => (takken_quality * selling_item['price']) - (selling_item['discount_percent'] * (takken_quality * selling_item['price'])/100)
          )
        end
        if @current_order.delivery == 0
          order_detail.status = Order.statuses[:finish]
        elsif @current_order.delivery == 1
          order_detail.status = Order.statuses[:delivery]
        end
        order_detail.save()

        #Trừ sản phẩm vào bảng Product(ko trừ nếu có giao hàng)
        product.available_quality -= takken_quality
        product.instock_quality -= takken_quality if @current_order.delivery == 0
        product.save()
        transactioned_quality += takken_quality
        if transactioned_quality == selling_item['sale_quality'] then break end
      end
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
