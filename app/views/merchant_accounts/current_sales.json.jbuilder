json.array!(@sales) do |me|
  # json.merge! me.attributes
  json.extract! me, :id, :account_id, :merchant_id, :branch_id, :current_warehouse_id
  # "id":2,"account_id":3,"merchant_id":2,"branch_id":2,"current_warehouse_id":2
end