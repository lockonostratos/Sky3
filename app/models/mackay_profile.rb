class MackayProfile < ActiveRecord::Base
  has_many :mackay_personals
  has_many :mackay_educations
  has_many :mackay_families
  has_many :mackay_childrens, :through => :mackay_families
  has_many :mackay_careers
  has_many :mackay_hobbies
  has_many :mackay_life_styles
  has_many :mackay_and_companies

  belongs_to :customer
  belongs_to :gera_customer
end