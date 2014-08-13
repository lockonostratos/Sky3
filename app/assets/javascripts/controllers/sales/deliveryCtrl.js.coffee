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

    @changeStatus = (item, value)=>
      if item.status == 2 and value
        item.status = 3
        item.update().then (data) => @calculationReturnStatus (data)
      if item.status == 2 and !value
        item.status = 4
        item.update().then (data) => @calculationReturnStatus (data)
      if item.status == 1 then item.status = 2; item.update().then (data) => @calculationReturnStatus (data)
      if item.status == 0 then item.status = 1; item.shipper = Common.currentMerchantAccount.id; item.update().then (data) => @calculationReturnStatus (data)




    @calculationReturnStatus = (item)=>
      if item.status == 0   then item.statusShow   = 'có thể nhận';           item.showButton = ['Nhận Giao Hàng']
      if item.status == 1   then item.statusShow   = 'đã nhận';               item.showButton = ['Đi Giao Hàng']
      if item.status == 2   then item.statusShow   = 'đang giao hàng';        item.showButton = ['Thành Công', 'Thất Bại']
      if item.status == 3   then item.statusShow   = 'Thành Công'
      if item.status == 4   then item.statusShow   = 'Thất Bại'
      if item.priority == 0 then item.showPriority = 'Bình Thường'
      if item.priority == 1 then item.showPriority = 'Ưu Tiên Loại 1'
      if item.priority == 2 then item.showPriority = 'Ưu Tiên Loại 2'
      if item.priority == 3 then item.showPriority = 'Ưu Tiên Loại 3'

      if !item.shipper                then item.showShipper = 'chưa có' else item.showShipper = item.shippers.displayName
      if !item.deliveryDateShipper    then item.showDeliveryDateShipper = 'chưa có' else item.showDeliveryDateShipper = item.deliveryDateShipper
      if !item.deliveryDateTransport  then item.showDeliveryDateTransport = 'chưa có' else item.showDeliveryDateTransport = item.deliveryDateTransport
      if !item.deliveryDateFinish     then item.showDeliveryDateFinish = 'chưa có' else item.showDeliveryDateFinish = item.deliveryDateFinish


      item

    return
]