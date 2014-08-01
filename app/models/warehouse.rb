class Warehouse < ActiveRecord::Base
  has_many :imports
  has_many :exports
  has_many :inventories
  has_many :orders
  has_many :products
  has_many :product_summaries
  has_many :role_warehouses
  has_many :metro_summaries

  belongs_to :branch
  belongs_to :merchant


  before_create :on_create_warehouse
  before_destroy :destroy_warehouse
  after_create :created_mertro_summary

  private
  def on_create_warehouse
  #  Bat loi khi Brach ko co
    if (Branch.find(self.branch_id)==nil)
    end
  end

  #Tạo MetroSummary sao khi tạo Waregouse
  def created_mertro_summary
    branch = Branch.find(self.branch_id)
    merchant = Merchant.find(branch.merchant.id)
    branches = Branch.where(merchant_id: merchant.id)
    merchant_accounts = MerchantAccount.where(branch_id:branches.pluck(:id))
    merchant_account = merchant_accounts.where(branch_id:self.branch_id)
    staff_count = 0
    staff_count_branch = 0
    merchant_accounts.each do |ex|
      staff_count += 1
    end
    merchant_account.each do |ex|
      staff_count_branch += 1
    end

    metro_summary = MetroSummary.new
    metro_summary.warehouse_id=self.id
    metro_summary.staff_count = staff_count
    metro_summary.staff_count_branch = staff_count_branch
    metro_summary.save()
  end


  def destroy_warehouse
    #Bat loi co skull Product va ProductSummary
    if(Import.find_by_warehouse_id(self.id)!=nil || Export.find_by_warehouse_id(self.id)!=nil || Inventory.find_by_warehouse_id(self.id)!=nil || Order.find_by_warehouse_id(self.id)!=nil || Product.find_by_warehouse_id(self.id)!=nil || ProductSummary.find_by_warehouse_id(self.id)!=nil)
    end

  end

  def self.search(val)
    where('name LIKE ?',  "%#{val}%")
  end

end