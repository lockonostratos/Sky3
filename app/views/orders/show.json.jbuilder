# json.merge! @order.attributes
json.(@order, :id, :name, :total_price, :discount_cash, :final_price, :status, :return)

json.seller do |json|
  json.(@order.seller.account, :display_name)
end

json.buyer do |json|
  json.(@order.buyer, :name)
end