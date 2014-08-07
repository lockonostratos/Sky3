class Customer < ActiveRecord::Base
  has_many :orders
  has_many :mackay_profiles
  has_many :mackay_personals, :through => :mackay_profiles
  has_many :mackay_educations, :through => :mackay_profiles
  has_many :mackay_families, :through => :mackay_profiles
  has_many :mackay_careers, :through => :mackay_profiles
  has_many :mackay_hobbies, :through => :mackay_profiles
  has_many :mackay_life_styles, :through => :mackay_profiles
  has_many :mackay_and_companies, :through => :mackay_profiles
  has_many :transactions, class_name: 'Transaction', foreign_key: 'owner_id'

  belongs_to :merchant
  belongs_to :merchant_account
  belongs_to :merchant_area

  after_create :recaculate_metro_summary

  def self.customers_of_brand(branch_id)
    Customer.where(branch_id: branch_id)
  end

  def self.customers_of_merchant(merchant_id)
    Customer.where(merchant_id: merchant_id)
  end

  private
  def recaculate_metro_summary
    brach = Branch.where(merchant_id: self.merchant_id)
    warehouse = Warehouse.where(branch_id:brach.pluck(:id))
    metro_summary = MetroSummary.where(warehouse_id: warehouse.pluck(:id))
    metro_summary.each do |metro_summary|
      metro_summary.customer_count += 1
      metro_summary.save()
    end
  end

end