class Agency < ActiveRecord::Base
  has_many :agency_accounts
  has_many :agency_areas
  has_many :agency_customers
  belongs_to :gera_account
end