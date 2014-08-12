class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  has_many   :return_details
end