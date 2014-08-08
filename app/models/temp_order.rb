class TempOrder < ActiveRecord::Base
  has_many   :details, :class_name => :TempOrderDetail
  belongs_to :branch
  belongs_to :warehouse

  belongs_to :creator,  :class_name => :MerchantAccount,  :foreign_key => :creator_id
  belongs_to :buyer,    :class_name => :Customer,         :foreign_key => :buyer_id
  belongs_to :seller,   :class_name => :MerchantAccount,  :foreign_key => :seller_id

  before_update :recalculation_order_details
  after_destroy :destroy_all_order_details

  def clone_to_order
    Order.create!(branch_id: self.branch_id,
                  warehouse_id: self.warehouse_id,
                  creator_id: self.creator_id,
                  seller_id: self.seller_id,
                  buyer_id: self.buyer_id,
                  name: orders_bill_code(self.warehouse_id),
                  status: :initializing,
                  delivery: self.delivery,
                  payment_method: self.payment_method,
                  bill_discount: self.bill_discount,
                  deposit: self.deposit,
                  debt: self.currency_debit,
                  discount_voucher: self.discount_voucher,
                  discount_cash: self.discount_cash,
                  total_price: self.total_price,
                  final_price: self.final_price)
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

  def calculation_payment
    if self.deposit >= self.final_price
      self.payment_method = 0
    else
      self.payment_method = 1
    end
    self.currency_debit = self.deposit - self.final_price
  end
  private
  #tính lại số tiền khi giá tiền lấy theo tổng bill hay từng sản phẩm, ko thay đổi thông tin từng sản phẩm
  def recalculation_order_details
    old_order = TempOrder.find(self.id)
    order_details = TempOrderDetail.where(temp_order_id: self.id)
    if old_order.bill_discount != self.bill_discount
      self.total_price = 0
      self.discount_cash = 0
      self.discount_percent = 0
      self.discount_voucher = 0
      order_details.each do |order_detail|
        self.total_price += order_detail.quality * order_detail.price
        if self.bill_discount
          self.final_price = self.total_price
        else
          self.discount_cash += order_detail.discount_cash
          self.discount_percent = self.discount_cash/(self.total_price.to_f/100)
          self.final_price = self.total_price - self.discount_cash
        end
      end
    end
    calculation_payment
  end

  def destroy_all_order_details
    order_details = TempOrderDetail.where(temp_order_id: self.id)
    order_details.each do |order_detail|
      order_detail.destroy()
    end
  end


end