class ReturnDetail < ActiveRecord::Base
  belongs_to :return
  belongs_to :order_detail
  belongs_to :product

end