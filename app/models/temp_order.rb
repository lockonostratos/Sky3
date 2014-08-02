class TempOrder < ActiveRecord::Base
  has_many   :details, :class_name => :TempOrderDetail
  belongs_to :branch
  belongs_to :warehouse

  belongs_to :creator,  :class_name => :MerchantAccount,  :foreign_key => :creator_id
  belongs_to :buyer,    :class_name => :Customer,         :foreign_key => :buyer_id
  belongs_to :seller,   :class_name => :MerchantAccount,  :foreign_key => :seller_id

  # before_update :reupdate_order_details
  after_destroy :destroy_all_order_details

  private
  # def reupdate_order_details
  #   old_order = TempOrder.find(self.id)
  #   order_details = TempOrderDetail.where(order_id: self.id)
  #   self.total_price = 0
  #   self.discount_cash = 0
  #   if old_order.bill_discount != self.bill_discount
  #     order_details.each do |order_detail|
  #       if self.bill_discount == true
  #         order_detail.temp_discount_percent = order_detail.discount_percent
  #         if self.discount_cash == 0
  #           order_detail.discount_percent = 0
  #         else
  #           order_detail.discount_percent = (self.discount_cash/self.total_price)*100
  #         end
  #       else
  #         order_detail.discount_percent = order_detail.temp_discount_percent
  #       end
  #       order_detail.discount_cash = (order_detail.discount_percent * order_detail.quality * order_detail.price)/100
  #       order_detail.total_amount = order_detail.quality * order_detail.price - order_detail.discount_cash
  #       order_detail.save()
  #       self.total_price += order_detail.quality * order_detail.price
  #       self.discount_cash += order_detail.discount_cash
  #     end
  #   else
  #     order_details.each do |order_detail|
  #       self.total_price += order_detail.quality * order_detail.price
  #       self.discount_cash += order_detail.discount_cash
  #     end
  #   end
  #   self.discount_voucher = 0 if self.bill_discount == true
  #   self.final_price = self.total_price - (self.discount_cash + self.discount_voucher)
  # end

  def destroy_all_order_details
    order_details = TempOrderDetail.where(order_id: self.id)
    order_details.each do |order_detail|
      order_detail.destroy()
    end
  end

end