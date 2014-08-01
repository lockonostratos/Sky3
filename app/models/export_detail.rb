class ExportDetail < ActiveRecord::Base
  belongs_to :export
  belongs_to :product
end