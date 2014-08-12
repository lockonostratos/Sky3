# json.merge! @delivery.attributes

json.shippers do |json|
  json.(@delivery.shippers.account, :display_name)
end
#
# json.buyer do |json|
#   json.(@order.buyer, :name)
# end