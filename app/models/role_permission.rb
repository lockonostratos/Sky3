class RolePermission < ActiveRecord::Base
  enum permission_key: [:administrator,
                        :sale,
                        :return,
                        :import,
                        :export,
                        :report]
  belongs_to :role
end