json.array!(@products) do |me|
  json.extract! me, :id, :product_code, :name, :import_quality, :available_quality, :instock_quality, :import_price, :expire
  json.skull do
    json.extract! me.skull, :id, :unit, :skull_01, :skull_02
  end
  json.provider do
    json.extract! me.provider, :id, :name
  end
  json.warehouse do
    json.extract! me.warehouse, :id, :name
  end



end


# json.array!(@products) do |me|
#   json.merge! me.attributes
# end

