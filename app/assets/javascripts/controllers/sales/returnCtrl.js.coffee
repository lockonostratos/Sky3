Sky.controller 'returnCtrl', ['$routeParams', 'Common', 'MerchantAccount', 'Warehouse', 'Order'
  ($routeParams, Common, MerchantAccount, Warehouse, Order) ->
    Common.caption = 'trả hàng'

    @warehouses = []; @currentWarehouse = {}
    Warehouse.get('available').then (data) =>
      @warehouses = data if data
      @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})
    @orders = []
    Order.query().then (data) => @orders = data



    return
]