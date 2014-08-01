class Return < ActiveRecord::Base
  has_many :return_details

  belongs_to :order
  belongs_to :merchant_account

end