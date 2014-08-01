json.array!(@product_summaries) do |me|
  json.merge! me.attributes
end