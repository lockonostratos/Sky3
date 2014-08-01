class GeraAccount < ActiveRecord::Base
  has_many :gera_areas
  has_many :gera_customers
  belongs_to :account
end