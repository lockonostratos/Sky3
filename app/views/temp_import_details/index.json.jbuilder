json.array!(@temp_import_details) do |me|
  json.extract! me, :id, :product_summary_id
  json.product_summary do
     json.extract! me.product_summary, :id, :name
  end
end