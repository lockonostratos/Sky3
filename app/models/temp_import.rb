class TempImport < ActiveRecord::Base
  has_many :temp_import_details

  belongs_to :warehouse
  belongs_to :merchant_account
end