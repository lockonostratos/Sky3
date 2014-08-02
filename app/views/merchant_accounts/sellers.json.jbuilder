json.array!(@sales) do |me|
  json.merge! me.attributes
end