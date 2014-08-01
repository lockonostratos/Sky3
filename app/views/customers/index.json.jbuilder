json.array!(@customers) do |me|
  json.merge! me.attributes
end