class Skull < ActiveRecord::Base
  has_many :products
  has_many :product_summaries
  belongs_to :merchant
  belongs_to :merchant_account

  before_create :create_skull
  before_destroy :destroy_skull

  #validates_numericality_of :
  private
  def create_skull
    #bat Merchant ton tai hay ko
    if (Merchant.find(self.merchant_id))
    end
    #bat MerchantAccount ton tai hay ko
    if(MerchantAccount.find(self.merchant_account_id))
    end
    #bat MerchantAccount.merchant_id = merchant_id
    if(MerchantAccount.find(self.merchant_account_id).merchant_id!=self.merchant_id)
    end

  end

  def destroy_skull
    #Bat loi co skull Product va ProductSummary
    if(Product.find_by_skull_id(self.id)!=nil || ProductSummary.find_by_skull_id(self.id)!=nil)
      MerchantBranche.create!
    end

  end
end