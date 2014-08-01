Sky.controller 'saleCtrl', ['$routeParams','$http', 'Common', 'Product', 'ProductSummary', 'Customer', 'MerchantAccount', 'TempOrder', 'TempOrderDetail'
($routeParams, $http, Common, Product, ProductSummary, Customer, MerchantAccount, TempOrder, TempOrderDetail) ->
  Common.caption = 'bán hàng';

  @Common = Common
  @transports = []; @transports.push obj for property, obj of Sky.Transports
  @payments = []; @payments.push obj for property, obj of Sky.Payments

  @seller = {}; @saleAccounts = []
  MerchantAccount.get('current_sales').then (data) =>
    @saleAccounts = data
    foundCurrent = data.find {accoundId: Common.currentMerchantAccount.account.id}
    @seller = foundCurrent ? @saleAccounts[0]

  @customer = {}; @customers = []
  Customer.query().then (data) => @customers = data; @customer = data[0]

  @tabHistories = []; @currentTab = {}; @tabDetails = [];
  TempOrder.query().then (data) =>
    @tabHistories = data
    if @tabHistories.length is 0
      @addTab()
    else
      @selectTab @tabHistories[0]


#  ProductSummary.query().then (data) =>



  #functions ---------------------------------------------
  @selectTab = (tab) =>
    @currentTab = tab
    @resetSellingProduct()
    @reloadSellerAndCustomer()
    @reloadTabDetails()

  @addTab = =>
    newTab = @newEmptyTab Sky.Conversation.Call @customer.name, @customer.sex
    newTab.save().then (data) => @tabHistories.push data

  @deleteTab = =>
    foundTab = @tabHistories.find {id: @currentTab.id}
    foundTab.delete() if foundTab
    @tabHistories.removeAt (@tabHistories.indexOf foundTab)
    @addTab() if tabHistories.length is 0

  @newEmptyTab = (name, branch_id = null, warehouse_id = null, merchant_account_id = null, sales_account_id =null, customer_id = null) =>
    newTab = new TempOrder({name: name})
    newTab.branch_id = branch_id ? Common.currentMerchantAccount.branch.id
    newTab.warehouse_id = warehouse_id ? Common.currentMerchantAccount.warehouse.id
    newTab.merchant_account_id = merchant_account_id ? Common.currentMerchantAccount.account.id
    newTab.sales_account_id = merchant_account_id ? Common.currentMerchantAccount.account.id
    newTab.customer_id = customer_id ? @customer.id
    newTab

    @resetSellingProduct = =>
      @sellingProduct = null
      @sellingDetail = null
      @searchText = null

    @reloadSellerAndCustomer = =>
      @seller = @saleAccounts.find { accoundId: @currentTab.salesAccountId }
      @customer = @customers.find { id: @currentTab.customerId }

    @reloadTabDetails = =>
      @tabDetails = []
      TempOrderDetail.query({order_id: @currentTab.id}).then (data) => @tabDetails = data

  return
]