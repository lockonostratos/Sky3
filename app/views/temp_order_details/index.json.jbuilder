json.array!(@temp_order_details) do |me|
  json.merge! me.attributes
end