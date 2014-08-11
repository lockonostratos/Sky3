Sky.controller 'inventoryCtrl', ['$routeParams', 'Common', 'MerchantAccount', 'Warehouse', 'Product', 'ProductSummary'
($routeParams, Common,MerchantAccount, Warehouse, Product, ProductSummary) ->
  Common.caption = 'kiểm kho'
  @message = 'message from inventory'

  return
]