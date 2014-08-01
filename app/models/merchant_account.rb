class MerchantAccount < ActiveRecord::Base
  has_many :customers
  has_many :skulls
  has_many :exports
  has_many :inventories
  has_many :orders
  has_many :deliveries
  has_many :returns
  has_many :imports
  has_many :merchant_areas
  has_many :product_summaries
  has_many :temp_import_details
  has_many :temp_products
  belongs_to :account
  belongs_to :merchant
  belongs_to :branch

  has_many :roles, class_name: 'MerchantAccountRole', foreign_key: 'merchant_account_id'
  belongs_to :warehouse, class_name: :Warehouse, foreign_key: 'current_warehouse_id'


  before_save :add_merchant_account
  after_create :add_staff_count_metro_summary

  scope :sales, -> { roles }

  def find_permissions
    result = MerchantAccountRole
             .joins("INNER JOIN role_permissions ON role_permissions.role_id = merchant_account_roles.role_id")
             .where("merchant_account_id = ?", self.id)
             .pluck("GROUP_CONCAT(DISTINCT permission_key)").first()

    result.split(',') if result
  end

  def move_to_warehouse (id)
    target_warehouse = Warehouse.find(id)
    if target_warehouse
      self.update({current_warehouse_id: target_warehouse.id, branch_id: target_warehouse.branch_id})
    else
      nil
    end

  end

  def move_to_branch (branch_id, warehouse_id)
    target_branch = Branch.find(branch_id)
    target_warehouse = Warehouse.find_by(id: warehouse_id, branch_id: branch_id)
    if target_branch and target_warehouse
      self.update({current_warehouse_id: target_warehouse.id, branch_id: target_branch.id})
    else
      nil
    end

  end

  def add_role_by_id(id)
    current_role = Role.find(id)
    MerchantAccountRole.create(role_id: current_role.id, merchant_account_id: self.id) if current_role
  end

  def add_role_by_name(name)
    current_role = Role.find_by_name(name)
    MerchantAccountRole.create(role_id: current_role.id, merchant_account_id: self.id) if current_role
  end

  private
  def add_merchant_account
    if (Merchant.find(self.merchant_id).id==nil || Account.find(self.account_id).id==nil)
    destroy
    end
  end

  def add_staff_count_metro_summary
    #Tìm Các Branch cùng thuộc 1 merchant
    branches = Branch.where(merchant_id:self.merchant_id)
     branch_id=[]
     branches.each do |brach|
       branch_id+=[brach.id]
     end

    #Tìm tất cả MerchantAccount thuộc 1 merchant
    merchant_accounts = MerchantAccount.where(branch_id:branch_id)
    #Lọc các merchant_account cùng 1 branch
    merchant_account = merchant_accounts.where(branch_id:self.branch_id)

    #Tìm tất cả Warehouse cùng thuộc 1 merchant
    warehouses = Warehouse.where(branch_id:branch_id)
    #Tìm tất cả Warehouse cùng 1 branch
    warehouse = warehouses.where(branch_id:self.branch_id)
    warehouses_id= []
    warehouses.each do |ware|
      warehouses_id+=[ware.id]
    end


    staff_count = 0
    staff_count_branch = 0
    #Đếm số lượng nhân viên tổng
    merchant_accounts.each do |ex|
      staff_count += 1
    end
    #Đếm số lượng nhân viên của branch
    merchant_account.each do |ex|
      staff_count_branch += 1
    end

    #lấy thông tin của bản MetroSummary
    metro_summaries = MetroSummary.where(warehouse_id:warehouses_id)
    metro_summary = metro_summaries.where(warehouse_id:warehouses_id)

    #Save thông tin của bảng Metrosummary
    metro_summaries.each do |metro|
      metro.staff_count = staff_count
      metro.save()
    end
    metro_summary.each do |metro|
      metro.staff_count_branch = staff_count_branch
      metro.save()
    end
  end
end