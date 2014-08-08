class TempOrderDetail < ActiveRecord::Base
  belongs_to :skull, class_name: :Skull, foreign_key: 'skull_id'
  belongs_to :temp_order
  belongs_to :product_summary

  after_destroy :update_temp_order #trừ tiền của sản phẩm đã xóa vào order
  after_save :recalculation_order


  private
  def update_temp_order
    @temp_order = TempOrder.where(id: self.temp_order_id).first
    if @temp_order and @temp_order.bill_discount
      @temp_order.total_price -= (self.quality * self.price)
      @temp_order.discount_cash -= (self.quality * self.price) * @temp_order.discount_percent/100
      @temp_order.final_price = (@temp_order.total_price - @temp_order.discount_cash) - @temp_order.discount_voucher
      @temp_order.calculation_payment
      @temp_order.save
    elsif @temp_order
      @temp_order.total_price -= (self.quality * self.price)
      @temp_order.discount_cash -= self.discount_cash
      @temp_order.final_price = (@temp_order.total_price - @temp_order.discount_cash) - @temp_order.discount_voucher
      @temp_order.calculation_payment
      @temp_order.save
    end
  end

  def recalculation_order
    @temp_order = TempOrder.where(id: self.temp_order_id).first
    if @temp_order
      @temp_order.total_price = 0
      @temp_order.discount_cash = 0
      TempOrderDetail.where(temp_order_id: @temp_order).each do |temp_order_detail|
        @temp_order.total_price += temp_order_detail.total_price
        @temp_order.discount_cash += temp_order_detail.discount_cash
      end
      if @temp_order.bill_discount
        @temp_order.discount_cash = @temp_order.discount_percent/100*@temp_order.total_price
        @temp_order.final_price = @temp_order.total_price - @temp_order.discount_cash
      else
        @temp_order.discount_percent = @temp_order.discount_cash/(@temp_order.total_price.to_f/100)
        @temp_order.final_price = @temp_order.total_price - @temp_order.discount_cash
      end
      @temp_order.calculation_payment
      @temp_order.save()
    end
  end
end