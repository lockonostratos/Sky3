class Inventory < ActiveRecord::Base
  has_many :inventory_details

  belongs_to :warehouse
  belongs_to :merchant_account
end