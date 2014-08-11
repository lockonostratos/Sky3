json.array!(@deliveries) do |me|
  json.merge! me.attributes
end