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
  after_create :increase_summary_quality, :increase_metro_summary_product_stock_count
  before_update :calculation_summary_quality, :calculation_metro_summary_stock_count
  after_destroy :decrease_summary_quality, :decrease_metro_summary_product_stock_count

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
      increase_metro_summary_product_count
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


  def increase_metro_summary_product_count
    metro_summary = MetroSummary.find_by_warehouse_id(self.warehouse_id)
    if metro_summary
      metro_summary.product_count += 1
      metro_summary.save()
    end
  end

  def increase_metro_summary_product_stock_count
    update_summary_quality
  end

  def decrease_metro_summary_product_stock_count
    update_summary_quality(false)
  end

  def update_metro_summary_product_stock_count(increase = true)
    metro_summary = MetroSummary.find_by_warehouse_id(self.warehouse_id)
    if metro_summary
      if increase
        metro_summary.stock_count += self.import_quality
      else
        metro_summary.stock_count += self.import_quality
      end
      metro_summary.save()
    end
  end


  def calculation_summary_quality
    old_product = Product.find(self.id)
    quality = old_product.instock_quality - self.instock_quality
    product_summary = find_product_summary
    if product_summary
      if quality > 0
        product_summary.quality -= quality
      else
        product_summary.quality += quality
      end
      product_summary.save()
    end
  end

  def calculation_metro_summary_stock_count
    old_product = Product.find(self.id)
    quality = old_product.instock_quality - self.instock_quality
    metro_summary = MetroSummary.find_by_warehouse_id(self.warehouse_id)
    if metro_summary
      if quality > 0
        metro_summary.stock_count -= quality
        metro_summary.sale_count += quality
        metro_summary.sale_count_day += quality
        metro_summary.sale_count_month += quality
      else
        metro_summary.stock_count += quality
        metro_summary.sale_count -= quality
        #TODO: xử lý kho trừ sản phẩm khi trả hàng theo ngay, tháng
      end
      metro_summary.save()
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
