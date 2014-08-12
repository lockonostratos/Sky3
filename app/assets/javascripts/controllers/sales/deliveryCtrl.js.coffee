Sky.controller 'deliveryCtrl', ['focus', '$routeParams','$http', 'Common', 'MerchantAccount', 'Warehouse', 'Delivery'
  (focus, $routeParams, $http, Common, MerchantAccount, Warehouse, Delivery) ->
    Common.caption = 'giao hàng'

    @showDelivery = 'all'
    @showButton = 'Nhận Giao Hàng'
    @deliveries = []
    @warehouses = []; @currentWarehouse = {}
    Warehouse.get('available').then (data) =>
      @warehouses = data if data
      @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})
      @changeView()

    @changeView = (item)=>
      if !item then item = @currentWarehouse
      if @showDelivery == 'all'
        Delivery.get('deliveries_of',{warehouse_id: item.id}).then (data) =>
          @deliveries = []
          for delivery in data
            @calculationReturnStatus (delivery)
            @deliveries.push delivery
      if @showDelivery == 'only'
        Delivery.get('deliveries_of',{warehouse_id: item.id, merchant_account_id: Common.currentMerchantAccount.account.id}).then (data) =>
          @deliveries = []
          for delivery in data
            @calculationReturnStatus (delivery)
            @deliveries.push delivery

    @changeCurrentWarehouse = (item) => console.log item

    @changeStatus = (item, index)=>
      if item.status == 0 #Nhân viên nhận đơn giao hàng
        item.status = 1
        item.shipper = Common.currentMerchantAccount.id
        item.update().then (data) => @calculationReturnStatus (data)
#      if item.status == 2 #Nhân viên nhận sản phẩm của đơn giao hàng
#      if item.status == 3 #Nhân viên đi giao đơn hàng
#      if item.status == 4 #Nhân viên giao hàng thành công
#      if item.status == 5 #Nhân viên giao thất bại


    @calculationReturnStatus = (item)=>
      if item.status == 0 then item.statusShow = 'có thể nhận'; item.showButton = 'Nhận Đơn Giao Hàng'
      if item.status == 1 then item.statusShow = 'đã nhận đơn hàng'; item.showButton = 'Đã Nhận SP Từ Kho'
      if item.status == 2 then item.statusShow = 'đã nhận sản phẩm đơn hàng'; item.showButton = 'Đang Đi Giao Hàng'
      if item.status == 3 then item.statusShow = 'đã đi giao đơn hàng'; item.showButton = 'Giao Thành - Thất Bại'
      if item.status == 4 then item.statusShow = 'đã giao hàng thành công'
      if item.status == 5 then item.statusShow = 'đã giao hàng thất bại'
      item

    return
]