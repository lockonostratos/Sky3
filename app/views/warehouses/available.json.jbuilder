json.array!(@warehouses) do |me|
  json.merge! me.attributes
end