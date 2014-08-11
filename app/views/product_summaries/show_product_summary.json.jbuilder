json.array!(@product_summaries) do |me|
  json.extract! me, :id, :warehouse_id, :product_code, :name, :quality, :price
  json.skull do
    json.extract! me.skull, :id, :unit, :skull_01, :skull_02
  end
end


# json.array!(@products) do |me|
#   json.merge! me.attributes
# end

