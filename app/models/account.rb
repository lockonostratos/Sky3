# encoding: UTF-8

class Account < ActiveRecord::Base
  has_one :merchant_account
  belongs_to :parent, class_name: :Account, foreign_key: :parent_id
  has_many :childs, class_name: :Account, foreign_key: :parent_id


  before_create { generate_auth_token(:auth_token) }
  after_create :create_extention_account

  has_secure_password
  enum extension: [:gera, :gera_customer, :agency, :agency_customer, :merchant, :merchant_customer]
  enum status: [:activated, :activating, :locked]

  def parent_merchant_account
    MerchantAccount.find_by_account_id (self.parent_id)
  end

  private
  def generate_auth_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Account.exists?(column => self[column])
  end

  def create_extention_account
    if self.gera?
      GeraAccount.create! ({account_id: self.id})
    elsif self.agency?
      AgencyAccount.create! ({account_id: self.id})
    elsif self.merchant?
      if merchant_exist?
        create_merchant_account_only
      else
        create_merchant_and_defaults
      end
    elsif self.gera_customer?
    elsif self.agency_customer?
    elsif self.merchant_customer?
    end
  end

  def create_merchant_account_only
    parent_merchant_account = self.parent_merchant_account
    self.update({headquater: parent_merchant_account.merchant_id})
    MerchantAccount.create! ({account_id: self.id,
                              merchant_id: parent_merchant_account.merchant_id,
                              branch_id: parent_merchant_account.branch_id,
                              current_warehouse_id: parent_merchant_account.current_warehouse_id})
  end

  def create_merchant_and_defaults
    new_merchant = Merchant.create! ({owner_id: self.id, name: self.email})
    self.update({headquater: new_merchant.id}) #Xác định xem người này trực thuộc tổ chức nào?
    new_branch = Branch.create! ({merchant_id: new_merchant.id, name: 'TRỤ SỞ'})
    new_merchant.update! ({headquater: new_branch.id})
    new_warehouse = Warehouse.find_by_branch_id(new_branch.id)
    MerchantAccount.create! ({account_id: self.id,
                              merchant_id: new_merchant.id,
                              branch_id: new_branch.id,
                              current_warehouse_id: new_warehouse.id})
  end

  def merchant_exist?
    self.parent_id != 0
  end
end







