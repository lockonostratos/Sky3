class Delivery < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :order
  belongs_to :merchant_account
  belongs_to :shippers, class_name: 'MerchantAccount', foreign_key: 'shipper'

  #[:khởi tạo, :NV đã nhận giao hàng, :NV đi giao hàng(khi nhận dc sản phẩm), :thành công , :thất bại]
  enum status: [:initializing, :delivery, :delivering, :finish, :cancelled]
end