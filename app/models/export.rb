class Export < ActiveRecord::Base
  has_many :export_detail

  belongs_to :merchant_account
  belongs_to :warehouse
end