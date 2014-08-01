class GeraArea < ActiveRecord::Base
  has_many :gera_customers
  belongs_to :gera_account
end