class ReturnDetail < ActiveRecord::Base
  belongs_to :return
  belongs_to :product

end