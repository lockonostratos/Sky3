class MerchantArea < ActiveRecord::Base
  has_many :customers

  belongs_to :merchant
  belongs_to :merchant_account

  before_save :add_area
  before_destroy :destroy_area

  # after_save :save_area
  private
  def add_area
    # if (Merchant.find(self.merchant_id).id==nil || MerchantAccount.find(self.merchant_account_id).id==nil)
    #   destroy
    # end
  end
  def destroy_area
    # if (Customer.find_by_area_id(self.id)!=nil)
    #   MerchantBranche.create!
    # end
  end

end