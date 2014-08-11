Sky.controller 'deliveryCtrl', ['focus', '$routeParams','$http', 'Common', 'MerchantAccount', 'Warehouse', 'Delivery'
  (focus, $routeParams, $http, Common, MerchantAccount, Warehouse, Delivery) ->
    Common.caption = 'giao hàng'

    @showDelivery = 'only'
    @deliveries = []
    @warehouses = []; @currentWarehouse = {}
    Warehouse.get('available').then (data) =>
      @warehouses = data if data
      @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})
      @changeView()

    @changeView = (item)=>
      if !item then item = @currentWarehouse
      if @showDelivery == 'all' then Delivery.get('deliveries_of',{warehouse_id: item.id}).then (data) => @deliveries = data
      if @showDelivery == 'only' then Delivery.get('deliveries_of',{warehouse_id: item.id, merchant_account_id: Common.currentMerchantAccount.account.id}).then (data) => @deliveries = data

    @changeCurrentWarehouse = (item) => console.log item



    return
]