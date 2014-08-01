class AgencyCustomer < ActiveRecord::Base
  has_many :mackay_profiles
  has_many :mackay_personals, :through => :mackay_profiles
  has_many :mackay_educations, :through => :mackay_profiles
  has_many :mackay_families, :through => :mackay_profiles
  has_many :mackay_careers, :through => :mackay_profiles
  has_many :mackay_hobbies, :through => :mackay_profiles
  has_many :mackay_life_styles, :through => :mackay_profiles
  has_many :mackay_and_companies, :through => :mackay_profiles

  belongs_to :agency
  belongs_to :agency_account
  belongs_to :agency_area

end