class Provider < ActiveRecord::Base
  has_many :products
  has_many :temp_import_details

  belongs_to :merchant

  before_save :create_provider
  before_destroy :destroy_provider

  private
  def create_provider
    if(Merchant.find(self.merchant_id)!=nil)
    end
  end

  def destroy_provider
    #Bat loi co skull Product va ProductSummary
    if(Product.find_by_provider_id(self.id)!=nil)
      MerchantBranche.create!
    end

  end
end
