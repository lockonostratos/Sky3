class AgencyAccount < ActiveRecord::Base
  has_many :agency_areas
  has_many :agency_customers
  belongs_to :account
  belongs_to :agency
end