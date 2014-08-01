class Product < ActiveRecord::Base
  #Add quan he
  has_many :export_details
  has_many :inventory_details
  has_many :order_details
  has_many :return_details
  belongs_to :provider
  belongs_to :warehouse
  belongs_to :import
  belongs_to :skull
  before_create :create_summary_unless_exist
  after_create :increase_summary_quality
  after_destroy :decrease_summary_quality

  def find_product_summary
    ProductSummary.find_by(product_code: self.product_code, skull_id: self.skull_id, warehouse_id: self.warehouse_id)
  end

  #Bat loi View
  #validates_presence_of :product_code, :provider, :warehouse, :import, :name, :import_quality, :import_price, :import_id
  #validates_numericality_of :warehouse_id, message: "nhap so"

  private
  def self.search(search)
    where(merchant_id LIKE 1).where('name LIKE ?' , "%#{search}%")
  end

  def create_summary_unless_exist
    product_summary = find_product_summary
    unless product_summary
      ProductSummary.create({product_code: self.product_code,
                             skull_id: self.skull_id,
                             warehouse_id: self.warehouse_id,
                             merchant_account_id: self.merchant_account_id,
                             name: self.name,
                             price: self.import_price})
    end
  end

  def increase_summary_quality
    update_summary_quality
  end

  def decrease_summary_quality
    update_summary_quality(false)
  end

  def update_summary_quality(increase = true)
    product_summary = find_product_summary

    if product_summary
      if increase
        product_summary.quality += self.import_quality
      else
        product_summary.quality -= self.import_quality
      end

      product_summary.save
    end
  end
end

=begin
Các trường hợp tạo mới PRODUCT
  1. Import (nhập kho) hàng mới
  2. Chuyển kho

Các trường hợp xóa PRODUCT
  1. Hủy phiếu nhập kho
=end
