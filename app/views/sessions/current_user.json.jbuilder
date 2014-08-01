json.(@account, :id, :extension, :headquater, :status, :email, :display_name, :last_name, :first_name)
json.parent do |json|
  json.(@account.parent, :id, :extension, :headquater, :status, :email, :display_name, :last_name, :first_name)
end