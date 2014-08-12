json.array!(@orders) do |me|
  json.extract! me, :id, :name, :warehouse_id
end