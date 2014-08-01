class GeraCustomer < ActiveRecord::Base
  has_many :mackay_profiles
  has_many :mackay_personals, :through => :mackay_profiles
  has_many :mackay_educations, :through => :mackay_profiles
  has_many :mackay_families, :through => :mackay_profiles
  has_many :mackay_careers, :through => :mackay_profiles
  has_many :mackay_hobbies, :through => :mackay_profiles
  has_many :mackay_life_styles, :through => :mackay_profiles
  has_many :mackay_and_companies, :through => :mackay_profiles

  belongs_to :gera_account
  belongs_to :gera_area

  def self.search(search)
    # where(gera_area_id:id).where('name LIKE ?' , "%#{search}%")
    where('name LIKE ?' , "%#{search}%")
  end
end