class MackayFamily < ActiveRecord::Base
  has_many :mackay_childrens
  belongs_to :mackay_profile
end