Sky.controller 'returnCtrl', ['$routeParams', 'Common', 'MerchantAccount', 'Warehouse', 'Order', 'Return',
  ($routeParams, Common, MerchantAccount, Warehouse, Order, Return) ->
    Common.caption = 'trả hàng'

    @showCreateReturn = false
    @showCurrentOrder = false
    @showSearchOrder = false

    @changeSearch = =>
      @showCreateReturn = false
      @showCurrentOrder = false

    @warehouses = []; @currentWarehouse = {}
    Warehouse.get('available').then (data) =>
      @warehouses = data if data
      @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})

    @orderSearch = []; @searchText = null; @isCollapsed = true
    @currentOrder = {}
    @selectOrder = =>
      @showSearchOrder  = !@showSearchOrder
      if @orderSearch.length is 0
        Order.get('search',{warehouse_id: @currentWarehouse.id}).then (data) => @orderSearch = data

    @orderFoundAction = (item)=>
      @showCurrentOrder = true
      Order.get(item.id).then (data) =>
        @currentOrder = data
        if @currentOrder.status == 'delivery' then @currentOrder.status = 'Đang Giao Hàng'
        if @currentOrder.status == 'finish' then @currentOrder.status = 'Thành Công'
        if @currentOrder.return == 'not_return' then @currentOrder.return = 'Không Có Trả Hàng'; @showCreateReturn = true
        if @currentOrder.return == 'returning' then @currentOrder.return = 'Đang Trả Hàng'; @showCreateReturn = false

    @createReturn = =>
      if @showCreateReturn
        newReturn = new Return({order_id: @currentOrder.id, name: @currentOrder.name})
        newReturn.save().then (data)=> console.log data





    return
]