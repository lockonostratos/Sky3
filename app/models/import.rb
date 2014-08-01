class Import < ActiveRecord::Base
  #Add quan he
  has_many :products
  belongs_to :warehouse
  belongs_to :merchant_account

  #Bat loi nhap
  validates_presence_of :warehouse, :merchant_account
  validates_numericality_of :warehouse_id, :merchant_account_id, message: "nhap so"


  #Bat loi tao, xoa
  before_destroy :destroy_import
  before_create :create_import


  private

  def create_import
    if (Warehouse.find(self.warehouse) || MerchantAccount.find(self.merchant_account))
    end
  end

  def destroy_import
    if Product.find_by_import_id(self.id) != nil
      MerchantBranche.create!
    end
  end
  end