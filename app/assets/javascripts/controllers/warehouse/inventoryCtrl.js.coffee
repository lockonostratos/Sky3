Sky.controller 'inventoryCtrl', ['$scope', '$routeParams', 'Common', 'MerchantAccount', 'Warehouse', 'Product'
($scope, $routeParams, Common,MerchantAccount, Warehouse, Product) ->
  Common.caption = 'kiểm kho'
  @message = 'message from inventory'

  @show = [{},{}]

  @warehouses = []; @currentWarehouse = {}
  Warehouse.get('available').then (data) =>
    @warehouses = data if data
    @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})
    console.log @currentWarehouse.id
  @products = []
  Product.query({warehouse_id: Common.currentMerchantAccount.warehouse.id}).then (data) => @products = data

  @changeCurrentWarehouse = (item) =>
    Product.query({warehouse_id: item.id}).then (data) => @products = data

  return
]