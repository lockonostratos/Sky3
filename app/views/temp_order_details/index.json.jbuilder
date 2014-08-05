json.array!(@temp_order_details) do |me|
  json.extract! me, :id, :temp_order_id, :product_summary_id, :skull_id, :product_code, :warehouse_id, :quality, :price,
                :discount_cash, :discount_percent, :final_price, :name
  json.skull do
    json.extract! me.skull, :id, :unit, :skull_01, :skull_02
  end
end