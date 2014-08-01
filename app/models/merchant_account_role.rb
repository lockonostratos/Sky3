class MerchantAccountRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :merchant_account

end