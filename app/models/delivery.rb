class Delivery < ActiveRecord::Base
  belongs_to :order
  belongs_to :merchant_account
end