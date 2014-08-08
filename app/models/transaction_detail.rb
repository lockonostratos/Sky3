class TransactionDetail < ActiveRecord::Base
  # belongs_to :transaction
  belongs_to :merchant
  belongs_to :branch
  belongs_to :warehouse


end