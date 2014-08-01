Sky.controller 'salesCtrl', ['$routeParams','$http', 'Common', 'Product', 'ProductSummary', 'Customer', 'MerchantAccount', 'TempOrder', 'TempOrderDetail'
($routeParams, $http, Common, Product, ProductSummary, Customer, MerchantAccount, TempOrder, TempOrderDetail) ->
  Common.caption = 'bán hàng'; me = @
  @transports = [
    {
      id: 0
      name: "Trực Tiếp"
    }
  ,
    {
      id: 1
      name: "Giao Hàng"
    }
  ]
  @payment_methods = [
    {
      id: 0
      name: "Tiền Mặt"
    }
  ,
    {
      id: 1
      name: "Nợ"
    }
  ]

  @tempOrder = {
    branch_id: Common.currentMerchantAccount.branchId
    warehouse_id: Common.currentMerchantAccount.currentWarehouseId
    name: 'new'}

  #Lấy thông tin nhân viên bán hàng
  @currentAccount = {}
  @sales_accounts = []
  MerchantAccount.get('current_sales').then (data) ->
    me.sales_accounts = data
    foundCurrent = me.sales_accounts.find({accountId: Common.currentMerchantAccount.accountId})
    me.currentAccount = if foundCurrent then foundCurrent else me.sales_accounts[0]
    me.tempOrder.merchant_account_id = me.currentAccount.accountId

  #Lấy thông tin khách hàng
  @currentCustomer = new Customer()
  @customers = []
  Customer.query().then (data) ->
    me.customers = data
    me.currentCustomer = data[0]
    me.tempOrder.customer_id =  me.currentCustomer.id

  #AddNewTab
  #TODO: Viết một hàm tạo mới TempOrder rỗng cho chinh nhánh & kho hiện tại.
  @addNewTab = =>
    newTab = me.newEmptyTab(me.getTraditionalCall me.currentCustomer.name, me.currentCustomer.sex)
    newTab.save().then (data) -> me.tempOrderTabs.push data
  @logName = -> console.log "#{me.currentCustomer.name} #{me.currentAccount.email}"

  #Load các TabOrders, nếu chưa tạo mới
  @tempOrderTabs = []
  TempOrder.query().then (data) ->
    me.tempOrderTabs = data
    if me.tempOrderTabs.length is 0
      me.tempOrder.branch_id = Common.currentMerchantAccount.branchId
      me.tempOrder.warehouse_id = Common.currentMerchantAccount.branchId
      #TODO: kiểm tra trường hợp thất bại
      TempOrder.$post('api/temp_orders', me.tempOrder).then (data) -> me.tempOrderTabs = [data]

  #Load thông tin tất cả order_detail của các OrderTab-
  #TODO: Không load tất cả dữ liệu một lần duy nhất nữa.
  @tempOrderDetailTabs = []
  TempOrderDetail.query().then (data) ->
    me.tempOrderDetailTabs = data
    for item in me.tempOrderDetailTabs when item.orderId == me.tempOrder.id then me.tempOrderDetails.push item

  #Load thông tin Search sản phẩm
  me.product_summaries = []
  ProductSummary.query().then (data) ->
    for item in data
      item.fullSearch = item.name
      item.fullSearch += ' (' + item.skullId + ')' if item.skullId
      me.product_summaries.push item
  #Chạy khi sản phẩm Search bị thay đổi
  @resetCurrentOrderDetail = ($item, $model, $label) ->
    me.currentOrderDetail = {}
    me.currentProduct = angular.copy $item
    #add dữ liệu ban đầu cho tempOrderDetail
    me.currentOrderDetail.order_id = me.tempOrder.id
    me.currentOrderDetail.product_summary_id = me.currentProduct.id
    me.currentOrderDetail.product_code = me.currentProduct.productCode
    me.currentOrderDetail.skull_id = me.currentProduct.skullId
    me.currentOrderDetail.warehouse_id = me.currentProduct.warehouseId
    me.currentOrderDetail.price = me.currentProduct.price
    me.currentOrderDetail.quality = 1
    me.currentOrderDetail.quality = 0 if calculation_max_sale_product(me.currentOrderDetail) <= 0
    me.currentOrderDetail.discount_cash = 0
    me.currentOrderDetail.discount_percent = 0
    me.currentOrderDetail.total_price = me.currentProduct.price * me.currentOrderDetail.quality
    me.currentOrderDetail.total_amount = me.currentProduct.price * me.currentOrderDetail.quality
    
  #Chuyển đổi dữ liệu qua lại giữa các TabOrders
  #TODO: load dữ liệu từ server (của tab hiện tại) thay vì lấy dữ liệu cũ được load 1 lần.
  #TODO: Gọi hàm Kiểm tra dữ liệu (order_details) xem nó có còn hợp lý hay không?
  @select_order = (item)->
    me.currentProduct = undefined
    me.currentOrderDetail = undefined
    me.tempOrder = item
    me.tempOrderDetails = []
    me.tempOrderDetails.push item for item in me.tempOrderDetailTabs when item.orderId == me.tempOrder.id

  @newEmptyTab = (name, branch_id = null, warehouse_id = null, merchant_account_id = null, customer_id = null) ->
    newTab = new TempOrder({name: name})
    newTab.branch_id = branch_id ? Common.currentMerchantAccount.branchId
    newTab.warehouse_id = warehouse_id ? Common.currentMerchantAccount.currentWarehouseId
    newTab.merchant_account_id = merchant_account_id ? me.currentAccount.accountId
    newTab.customer_id = customer_id ? me.currentCustomer.id
    newTab

  @getTraditionalCall = (fullName, gender) ->
    postTitle = if gender then 'Anh ' else 'Chị '
    postTitle + fullName.split(' ').pop()

  #RemoveTab
  @removeTab = ->
    foundTab = me.tempOrderTabs.find({id: me.tempOrder.id})
    foundTab.delete()
    me.tempOrderTabs.removeAt me.tempOrderTabs.indexOf foundTab
    if me.tempOrderTabs.length is 0
      newTab = me.newEmptyTab(me.getTraditionalCall me.currentCustomer.name, me.currentCustomer.sex)
      newTab.save().then (data) -> me.tempOrderTabs.push data
#
#      me.tempOrder = {
#        branch_id: Common.currentMerchantAccount.branchId
#        warehouse_id: Common.currentMerchantAccount.currentWarehouseId
#        merchant_account_id: @currentAccount.accountId
#        customer_id: @currentAccount.accountId
#        name: @currentCustomer.name}
#      TempOrder.$post('api/temp_orders', me.tempOrder).then (data) ->
#        @tempOrderTabs.push data


  #Bắt lôi của OrderDetail khi các thông tin thay đổi
  @addNewOrderDetail = (item) -> calculation_addNewOrderDetail(item)
  @removeOrderDetail = (item, index) -> calculation_removeOrderDetail(item, index)
  @changeCurrentOrderDetailQuality = (item)-> calculation_tempOrderDetail(item, true)
  @change_tempOrderDetail_discount_cash = (item)-> calculation_tempOrderDetail(item, true)
  @change_tempOrderDetail_discount_percent = (item)-> calculation_tempOrderDetail(item, false)
  #Cập nhật Order khi các thông tin thay đổi
  @changeCurrentOrderOwnerId = -> me.tempOrder.merchantAccountId = me.currentAccount.accountId

  @change_currentCustomer = (item)->
    me.tempOrder.customerId = item.id
#    @currentCustomer = item
    me.tempOrder.update()

  @change_current_payment_method = (item)-> me.tempOrder.paymentMethod = item.id
  @change_current_delivery = (item)-> me.tempOrder.delivery = item.id
  #Cập nhật Order khi các thông tin thay đổi
  @change_tempOrder_discount_percent = (item)-> calculation_tempOrder(item, false)
  @change_tempOrder_discount_cash = (item)-> calculation_tempOrder(item, true)
  @change_cheked_bill =(item) -> rechange_temp_order_detail(item)
  @change_bill_discount =() -> change_bill_discount()
  @change_tempOrder_discountVoucher = (item) ->
    me.tempOrder.discountVoucher = calculation_item_range_min_max(item, 0, (me.tempOrder.totalPrice - me.tempOrder.discountCash))
    me.tempOrder.finalPrice = (me.tempOrder.totalPrice - me.tempOrder.discountCash) - me.tempOrder.discountVoucher
  @reupdate_order =() -> me.tempOrder.update()




#add sản phẩm vào girdview---------------------------------------------------------------------------------->

  #Add sản phẩm vào GirdView
  calculation_addNewOrderDetail = (item)->
    item.temp_discount_percent = item.discount_percent
    if me.tempOrder.billDiscount == true
      item.discount_percent = 0
      item.temp_discount_percent = 0
      item.discount_cash = 0
      item.total_amount = item.quality * item.price
    if me.currentOrderDetail.quality > 0
      me.a = true
      for product, index in me.tempOrderDetails
        if (product.productSummaryId == item.product_summary_id and product.discountPercent == item.discount_percent)
          product.quality += item.quality
          product.discountCash = (product.discountPercent*(product.quality * product.price))/100
          product.totalAmount = (product.quality * product.price) - product.discountCash
          product.update()
          if me.currentOrderDetail.quality > calculation_max_sale_product() then me.currentOrderDetail.quality = calculation_max_sale_product()
          me.tempOrder.update()
          me.a = false
      if me.a
        Sky.gs('TempOrderDetail').$post('api/temp_order_details', item).then (data) ->
          me.tempOrderDetailTabs.push data
          me.tempOrderDetails.push data
          me.tempOrder.update().then (data) ->
            #Thêm hàm tính toán nếu data chưa load kịp
#          recalculation_tempOrder(me.tempOrder) = data
#            me.tempOrder = data
#          for item in me.tempOrderDetailTabs when item.orderId == me.tempOrder.id then me.tempOrderDetails.push item
#          if me.tempOrderDetail.quality > calculation_max_sale_product() then me.tempOrderDetail.quality = calculation_max_sale_product()


  #Xóa sản phẩm vào GirdView
  calculation_removeOrderDetail = (item, index)->
    item.delete()
    me.tempOrderDetails.splice index, 1
    for product, i in me.tempOrderDetailTabs when product.id == item.id then me.tempOrderDetailTabs.splice i, 1

#    if me.tempOrderDetails[0] == undefined then me.tempOrder.billDiscount = false

#  recalculation_tempOrder =()->
#    me.tempOrder.totalPrice = 0
#    me.tempOrder.finalPrice = 0
#    me.tempOrder.discountCash = 0
#    update_tempOrder(me.tempOrder, product) for product, index in me.tempOrderDetails
#    if me.tempOrder.discountCash == 0 then me.tempOrder.discountPercent = 0 else me.tempOrder.discountPercent = (me.tempOrder.discountCash * 100)/me.tempOrder.totalPrice
#    me.tempOrder.finalPrice = me.tempOrder.finalPrice - me.tempOrder.discountVoucher
#    me.tempOrder.update()
#  update_tempOrder = (item, product)->
#    if me.tempOrder.billDiscount == true
#      item.totalPrice += (product.price * product.quality)
#      item.finalPrice += (product.price * product.quality)
#    else
#      item.totalPrice += (product.price * product.quality)
#      item.finalPrice += product.totalAmount
#      item.discountCash += product.discountCash
  recalculation_tempOrder =(item) ->
    item.totalPrice = 0
    for product in me.tempOrderDetails
      item.totalPrice += product.quality * product.price
    item.discountCash = (item.discountPercent * item.totalPrice)/100
    item.finalPrice = item.totalPrice - item.discountCash





  calculation_item_range_min_max = (item, min, max)->
    if item == undefined || item == 0 || item == null then item = min
    if item > max then item = max
    return  item
  #Tính toán giới hạng mua sản phẩm
  calculation_max_sale_product = ->
    temp = 0
    a=0
    for product in me.tempOrderDetailTabs
      if product.productSummaryId == me.currentProduct.id then temp += product.quality
    a = me.currentProduct.quality - temp
    return a

  #Tính toán OrderDetail
  calculation_tempOrderDetail = (item, boolean)->
    item.quality = calculation_item_range_min_max(item.quality, 0, calculation_max_sale_product())
    item.total_price =  item.quality * item.price
    item.discount_cash = calculation_item_range_min_max(item.discount_cash, 0, item.total_price)
    item.discount_percent = calculation_item_range_min_max(item.discount_percent, 0, 100)
    if item.quality > 0
      if boolean
        item.discount_percent = (item.discount_cash/item.total_price)*100
      else
        item.discount_cash = (item.discount_percent*item.total_price)/100
    else
      item.discount_percent = 0
      item.discount_cash = 0
    item.total_amount = item.total_price - item.discount_cash
  #Tính toán Order
  calculation_tempOrder = (item, boolean)->
    item.discountCash = calculation_item_range_min_max(item.discountCash, 0, item.totalPrice)
    item.discountPercent = calculation_item_range_min_max(item.discountPercent, 0, 100)
    if boolean
      item.discountPercent = (item.discountCash/item.totalPrice)*100
    else
      item.discountCash = (item.discountPercent*item.totalPrice)/100
    item.finalPrice = item.totalPrice - item.discountCash
  #Tính lại Order khi check giảm giá theo Tổng Bill
  rechange_temp_order_detail = (item) ->
    if item
      me.tempOrder.discountVoucher = me.tempOrder.discountCash = me.tempOrder.discountPercent = 0
      me.tempOrder.finalPrice = me.tempOrder.totalPrice
    me.tempOrder.update()
    TempOrderDetail.get('current_temp_order_details',{order_id:me.tempOrder.id}).then (data) ->
      me.tempOrderDetails = data
      for old_product, index in me.tempOrderDetailTabs
        for new_product in me.tempOrderDetails
          if new_product.id == old_product.id
            old_product.discountCash = new_product.discountCash
            old_product.discountPercent = new_product.discountPercent
            old_product.totalAmount = new_product.totalAmount
  #Trang thái
  change_bill_discount = () ->
    disabled = true
    if me.tempOrder.billDiscount == true then disabled = true  else disabled = false
    if me.tempOrderDetails[0] == undefined then disabled = true
    return disabled

  return
]