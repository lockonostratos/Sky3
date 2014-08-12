class Return < ActiveRecord::Base
  belongs_to :branch
  belongs_to :warehouse
  belongs_to :order
  belongs_to :creator, class_name: 'MerchantAccount', foreign_key: 'creator_id'

  has_many :return_details

end