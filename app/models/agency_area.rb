class AgencyArea < ActiveRecord::Base
  belongs_to :agency
  belongs_to :agency_account
end