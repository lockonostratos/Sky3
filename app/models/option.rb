class Option < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :branch

  enum transport: [:direct, :delivery]
  enum payment_method: [:cash, :bank, :voucher]
end