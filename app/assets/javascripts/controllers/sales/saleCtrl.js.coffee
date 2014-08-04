Sky.controller 'saleCtrl', ['$routeParams','$http', 'Common', 'Product', 'ProductSummary', 'Customer', 'MerchantAccount', 'TempOrder', 'TempOrderDetail'
($routeParams, $http, Common, Product, ProductSummary, Customer, MerchantAccount, TempOrder, TempOrderDetail) ->
  Common.caption = 'bán hàng';

  @Common = Common
  @transports = []; @transports.push obj for property, obj of Sky.Transports
  @payments = []; @payments.push obj for property, obj of Sky.Payments

  @seller = {}; @saleAccounts = []
  MerchantAccount.get('sellers').then (data) =>
    @saleAccounts = data
    foundCurrent = data.find {accoundId: Common.currentMerchantAccount.account.id}
    @seller = foundCurrent ? @saleAccounts[0]

  @buyer = {}; @customers = []
  Customer.query().then (data) => @customers = data; @buyer = data[0]

  @tabHistories = []; @currentTab = null; @tabDetails = [];
  TempOrder.query().then (data) =>
    @tabHistories = data
    if @tabHistories.length is 0
      @addTab()
    else
      @selectTab @tabHistories[0]

  @allProducts = [];
  ProductSummary.query().then (data) =>
    for product in data
      product.caption = product.name
      product.caption += " (#{product.skullId})" if product.skullId
      @allProducts.push product

#  ProductSummary.query().then (data) =>

  # Bindable functions ----------------------------------------->
  @syncSeller = (model) => @currentTab.sellerId = model.id; @currentTab.update()
  @syncBuyer = (model) => @currentTab.buyerId = model.id; @currentTab.update()

  @skyChange = => console.log 'bing!'

  # Helper functions --------------------------------------------->
  @selectTab = (tab) =>
    @currentTab = tab
    @resetSellingProduct()
    @reloadSellerAndCustomer()
    @reloadTabDetails()

  @addTab = =>
    console.log 'creating..'
    newTab = @newEmptyTab (Sky.Conversation.Call @buyer.name, @buyer.sex)
    newTab.save().then (data) => @tabHistories.push data

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

  @resetSellingProduct = =>
    @sellingProduct = null
    @sellingDetail = null
    @searchText = null

  @reloadSellerAndCustomer = =>
    @seller = @saleAccounts.find { id: @currentTab.sellerId }
    @buyer = @customers.find { id: @currentTab.buyerId }

  @reloadTabDetails = =>
    @tabDetails = []
    TempOrderDetail.query({temp_order_id: @currentTab.id}).then (data) => @tabDetails = data

  return
]