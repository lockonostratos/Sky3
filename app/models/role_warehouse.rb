class RoleWarehouse < ActiveRecord::Base
  belongs_to :role
  belongs_to :warehouse
end