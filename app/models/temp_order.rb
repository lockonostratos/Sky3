class TempOrder < ActiveRecord::Base
  has_many   :details, :class_name => :TempOrderDetail
  belongs_to :branch
  belongs_to :warehouse

  belongs_to :creator,  :class_name => :MerchantAccount,  :foreign_key => :creator_id
  belongs_to :buyer,    :class_name => :Customer,         :foreign_key => :buyer_id
  belongs_to :seller,   :class_name => :MerchantAccount,  :foreign_key => :seller_id

  before_update :recalculation_order_details
  after_destroy :destroy_all_order_details

  private
  #tính lại số tiền khi giá tiền lấy theo tổng bill hay từng sản phẩm, ko thay đổi thông tin từng sản phẩm
  def recalculation_order_details
    old_order = TempOrder.find(self.id)
    order_details = TempOrderDetail.where(temp_order_id: self.id)
    if old_order.bill_discount != self.bill_discount
      self.total_price = 0
      self.discount_cash = 0
      self.discount_voucher = 0
      order_details.each do |order_detail|
        self.total_price += order_detail.quality * order_detail.price
        self.bill_discount ?
            self.final_price = self.total_price :
            self.final_price = self.total_price - order_detail.discount_cash
      end
    end
  end

  def destroy_all_order_details
    order_details = TempOrderDetail.where(temp_order_id: self.id)
    order_details.each do |order_detail|
      order_detail.destroy()
    end
  end

end