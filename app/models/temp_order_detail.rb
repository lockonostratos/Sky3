class TempOrderDetail < ActiveRecord::Base
  belongs_to :skull, class_name: :Skull, foreign_key: 'skull_id'
  belongs_to :temp_order
  belongs_to :product_summary

  before_destroy :update_temp_order #trừ tiền của sản phẩm đã xóa vào order

  private
  def update_temp_order
    @temp_order = TempOrder.find(self.temp_order_id)
    @temp_order.total_price -= (self.quality * self.price)
    @temp_order.discount_cash -= self.discount_cash
    @temp_order.final_price = (@temp_order.total_price - @temp_order.discount_cash) - @temp_order.discount_voucher
    @temp_order.save
  end
end