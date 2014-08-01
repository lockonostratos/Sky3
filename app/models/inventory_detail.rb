class InventoryDetail < ActiveRecord::Base
  belongs_to :product
  belongs_to :inventory
end