class TempImportDetail < ActiveRecord::Base
  belongs_to :product_summary
  belongs_to :merchant_account
  belongs_to :provider
end