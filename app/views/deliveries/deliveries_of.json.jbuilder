json.array!(@deliveries) do |me|
  json.merge! me.attributes

  if me.shipper
    json.shippers do
      json.extract! me.shippers.account, :display_name
    end
  end
end