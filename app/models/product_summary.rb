class ProductSummary < ActiveRecord::Base
  belongs_to :skull
  belongs_to :warehouse
  belongs_to :merchant_account
  has_many :temp_products

  def self.products_of(warehouse_id)
    ProductSummary.where(warehouse_id: warehouse_id)
  end

  #Search-------------------------------->
  include Tire::Model::Search
  include Tire::Model::Callbacks

  private
  # def self.search(search)
  #   where('name LIKE ?' , "%#{search}%")
  # end
end