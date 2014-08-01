class TempProduct < ActiveRecord::Base
 belongs_to :product_summary
 belongs_to :merchant_account
end