json.(@merchant_account, :id)

json.account do |json|
  json.(@merchant_account.account, :id, :extension, :headquater, :status, :email, :display_name, :last_name, :first_name)
end

json.merchant do |json|
  json.(@merchant_account.merchant, :id, :headquater, :name)
end

json.branch do |json|
  json.(@merchant_account.branch, :id, :name)
end

json.warehouse do |json|
  json.(@merchant_account.warehouse, :id, :name)
end