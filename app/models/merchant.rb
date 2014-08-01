class Merchant < ActiveRecord::Base
  has_many :merchant_accounts
  has_many :customers
  has_many :branches
  has_many :skulls
  has_many :providers
  has_many :warehouses
  has_many :merchant_areas

  def find_sales
    result = MerchantAccount
    .joins("INNER JOIN merchant_account_roles ON merchant_accounts.id = merchant_account_roles.merchant_account_id")
    .joins("INNER JOIN role_permissions ON merchant_account_roles.role_id = role_permissions.role_id")
    .joins("INNER JOIN accounts ON accounts.id = merchant_accounts.account_id")
    .where("merchant_id = ? AND permission_key = ?", self.id, RolePermission.permission_keys[:sale])
    .group(:account_id)
    .select("merchant_accounts.*, accounts.first_name, accounts.last_name, accounts.display_name, accounts.email")
  end

  def self.find_branch_sales (branch_id)
    result = MerchantAccount
    .joins("INNER JOIN merchant_account_roles ON merchant_accounts.id = merchant_account_roles.merchant_account_id")
    .joins("INNER JOIN role_permissions ON merchant_account_roles.role_id = role_permissions.role_id")
    .joins("INNER JOIN accounts ON accounts.id = merchant_accounts.account_id")
    .where("branch_id = ? AND permission_key = ?", branch_id, RolePermission.permission_keys[:sale])
    .group(:account_id)
    .select("merchant_accounts.*, accounts.first_name, accounts.last_name, accounts.display_name, accounts.email")
  end
end