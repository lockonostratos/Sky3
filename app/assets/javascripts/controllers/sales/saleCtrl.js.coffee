Sky.controller 'saleCtrl', ['$routeParams','$http', 'Common', 'Product', 'ProductSummary', 'Customer', 'MerchantAccount', 'TempOrder', 'TempOrderDetail'
($routeParams, $http, Common, Product, ProductSummary, Customer, MerchantAccount, TempOrder, TempOrderDetail) ->
  Common.caption = 'bán hàng';

  @Common = Common
  @transports = []; @transport={}; @transports.push obj for property, obj of Sky.Transports
  @payments = []; @payment={}; @payments.push obj for property, obj of Sky.Payments

  @seller = {}; @saleAccounts = []
  MerchantAccount.get('sellers').then (data) =>
    @saleAccounts = data
    foundCurrent = data.find {accoundId: Common.currentMerchantAccount.account.id}
    @seller = foundCurrent ? @saleAccounts[0]

  @buyer = {}; @customers = []
  Customer.query().then (data) => @customers = data; @buyer = data[0]

  @tabHistories = []; @currentTab = {}; @tabDetails = [];
  TempOrder.query().then (data) =>
    @tabHistories = data
    if @tabHistories.length is 0
      @addTab()
    else
      @selectTab @tabHistories[0]

  @productSummaries = []
  ProductSummary.query().then (data) =>
    for item in data
      item.fullSearch = item.name
      item.fullSearch += ' (' + item.skullId + ')' if item.skullId
      @productSummaries.push item

  @allProducts = [];
  ProductSummary.query().then (data) =>
    for product in data
      product.caption = product.name
      product.caption += " (#{product.skullId})" if product.skullId
      @allProducts.push product

#  ProductSummary.query().then (data) =>
  @resetCurrentOrderDetail = ($item, $model, $label) =>
    @currentOrderDetail = new TempOrderDetail()
    ProductSummary.get($item.id).then (data) =>
      @currentProduct = data
      @currentProduct.fullSearch = $item.fullSearch
      #add dữ liệu ban đầu cho tempOrderDetail
      @currentOrderDetail.name = @currentProduct.name
      @currentOrderDetail.tempOrderId = @currentTab.id
      @currentOrderDetail.productSummaryId = @currentProduct.id
      @currentOrderDetail.productCode = @currentProduct.productCode
      @currentOrderDetail.skullId = @currentProduct.skullId
      @currentOrderDetail.warehouseId = @currentProduct.warehouseId
      @currentOrderDetail.price = @currentProduct.price
      @currentOrderDetail.quality = 1
#      @currentOrderDetail.quality = 0 if calculation_max_sale_product(me.currentOrderDetail) <= 0
      @currentOrderDetail.discountCash = 0
      @currentOrderDetail.discountPercent = 0
      @currentOrderDetail.totalPrice = @currentProduct.price * @currentOrderDetail.quality
      @currentOrderDetail.totalAmount = @currentProduct.price * @currentOrderDetail.quality

  # Bindable functions ----------------------------------------->
  @syncSeller = (model) => @currentTab.sellerId = model.id; @currentTab.update()
  @syncBuyer = (model) => @currentTab.buyerId = model.id; @currentTab.update()
  @syncTransport = (model) => @currentTab.delivery = model.value; @currentTab.update()
  @syncPayment = (model) => @currentTab.paymentMethod = model.value; @currentTab.update()
  @syncBillDiscount = (model) =>
    @currentTab.billDiscount = model
    @currentTab.update()
    @resetCurrentTab(@currentTab)



  @skyChange = => console.log 'bing!'

  # Helper functions --------------------------------------------->
  @selectTab = (tab) =>
    @resetCurrentTab(tab) #tính giảm giá % khi hện bill
    @resetSellingProduct()
    @reloadSellerAndCustomerAndTransportAndPayment()
    @reloadTabDetails()

  @addTab = =>
    console.log 'creating..'
    newTab = @newEmptyTab (Sky.Conversation.Call @buyer.name, @buyer.sex)
    newTab.save().then (data) => @tabHistories.push data; @tabHistories[@tabHistories.indexOf data].active = true

  @deleteTab = (tab) =>
    foundTab = @tabHistories.find {id: tab.id}
    foundTab.delete() if foundTab
    currentIndex = @tabHistories.indexOf foundTab
    @tabHistories.removeAt currentIndex
    @currentTab = @tabHistories[currentIndex] ? @tabHistories[currentIndex - 1]
    console.log @currentTab
    @addTab() if @tabHistories.length is 0

  @newEmptyTab = (name, branch_id = null, warehouse_id = null, creator_id = null, seller_id =null, buyer_id = null) =>
    newTab = new TempOrder({name: name})
    newTab.branch_id = branch_id ? Common.currentMerchantAccount.branch.id
    newTab.warehouse_id = warehouse_id ? Common.currentMerchantAccount.warehouse.id
    newTab.creator_id = creator_id ? Common.currentMerchantAccount.account.id
    newTab.seller_id = seller_id ? @seller.id
    newTab.buyer_id = buyer_id ? @buyer.id
    newTab

  @resetCurrentTab= (tab)=>
    @currentTab = tab
    if @currentTab.discountCash == 0
      @currentTab.discountPercent = 0
    else
      @currentTab.discountPercent = @currentTab.discountCash/@currentTab.totalPrice*100
    @currentTab

  @resetSellingProduct = =>
    @sellingProduct = null
    @sellingDetail = null
    @searchText = null

  @reloadSellerAndCustomerAndTransportAndPayment = =>
    @seller = @saleAccounts.find { id: @currentTab.sellerId }
    @buyer = @customers.find { id: @currentTab.buyerId }
    @transport = @transports.find {value: @currentTab.delivery}
    @payment = @payments.find {value: @currentTab.paymentMethod}

  @reloadTabDetails = =>
    @tabDetails = []
    TempOrderDetail.query({temp_order_id: @currentTab.id}).then (data) => @tabDetails = data

  @reloadCurrentTab = => TempOrder.get(@currentTab.id).then (data) =>  @currentTab = data; @resetCurrentTab(@currentTab)

  @addSellingProduct = =>
    if @currentProduct != undefined and @currentOrderDetail.quality >= 1
      temp = angular.copy @currentOrderDetail
      temp.save().then (data) =>
        foundOrderDetail = @tabDetails.find {id: data.id}
        if foundOrderDetail
          foundOrderDetail.quality = data.quality
          foundOrderDetail.discountCash = data.discountCash
          foundOrderDetail.totalAmount = data.totalAmount
        else
          @tabDetails.push data
        @reloadCurrentTab()

  @removeSellingProduct = (item, index)=> item.delete(); @tabDetails.splice index, 1; @reloadCurrentTab(@currentTab)

  @calculation_currentTab = (item, boolean)=>
    item.discountCash = @calculation_item_range_min_max(item.discountCash, 0, item.totalPrice)
    item.discountPercent = @calculation_item_range_min_max(item.discountPercent, 0, 100)
    if boolean
      item.discountPercent = (item.discountCash/item.totalPrice)*100
    else
      item.discountCash = (item.discountPercent*item.totalPrice)/100
    item.finalPrice = item.totalPrice - item.discountCash

  @calculation_tabDetails = (item, boolean)=>
    item.quality = @calculation_item_range_min_max(item.quality, 0, @calculation_max_sale_product())
    item.totalPrice =  item.quality * item.price
    item.discountCash = @calculation_item_range_min_max(item.discountCash, 0, item.totalPrice)
    item.discountPercent = @calculation_item_range_min_max(item.discountPercent, 0, 100)
    if item.quality > 0
      if boolean
        item.discountPercent = (item.discountCash/item.totalPrice)*100
      else
        item.discountCash = (item.discountPercent*item.totalPrice)/100
    else
      item.discountPercent = 0
      item.discountCash = 0
    item.totalAmount = item.totalPrice - item.discountCash

  @calculation_max_sale_product = ()=>
    temp = 0
    for product in @tabDetails
      if product.productSummaryId == @currentProduct.id then temp += product.quality
    temp = @currentProduct.quality - temp
    temp

  @calculation_item_range_min_max = (item, min, max)=>
    if item == undefined || item == 0 || item == null then item = min
    if item > max then item = max
    item

  @change_bill_discount = =>
    disabled = true
    if @currentTab.billDiscount == true then disabled = true  else disabled = false
    if @tabDetails[0] == undefined then disabled = true
    disabled


  return
]