class Order < ActiveRecord::Base
  has_many :order_details
  has_many :deliveries
  has_many :returns

  belongs_to :branch
  belongs_to :warehouse
  belongs_to :merchant_account
  belongs_to :customer
end