class Option < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :branch

  enum transport: [:gera, :agency, :merchant]
  enum payment_method: [:gera, :agency, :merchant]



end