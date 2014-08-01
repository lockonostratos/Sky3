json.array!(@temp_import_details) do |me|
  json.extract! me, :id, :import_price, :import_quality
  json.product_summary do
     json.extract! me.product_summary, :id, :name
  end
end