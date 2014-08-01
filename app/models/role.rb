class Role < ActiveRecord::Base
  has_many :permissions, class_name: 'RolePermission', foreign_key: 'role_id'
  enum extension: [:gera, :agency, :merchant]

  def add_permission(key)
    RolePermission.create(role_id: self.id, permission_key: key)

  end

  def clone(base_name, new_name)
    base_role = Role.find_by_name(base_name)
    if base_role
      extended_role = Role.create(name: new_name, headquater: base_role.headquater)
      base_permissions = RolePermission.where(role_id: base_role.id)

      for permission in base_permissions
        extended_role.add_permission(permission.permission_key)
      end
    end
  end
end