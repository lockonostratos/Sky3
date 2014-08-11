Sky.controller 'listCtrl', ['$routeParams', 'Common', 'MerchantAccount', 'Warehouse', 'Product', 'ProductSummary'
($routeParams, Common,MerchantAccount, Warehouse, Product, ProductSummary) ->
  Common.caption = 'tồn kho'
  @message = 'message from inventory'


  @warehouses = []; @currentWarehouse = {}
  Warehouse.get('available').then (data) =>
    @warehouses = data if data
    @currentWarehouse = @warehouses.find ({id: Common.currentMerchantAccount.warehouse.id})
  @products = []
  ProductSummary.get('show_product_summary',{warehouse_id: Common.currentMerchantAccount.warehouse.id}).then (data) => @products = data

  @changeCurrentWarehouse = (item) =>
    ProductSummary.get('show_product_summary',{warehouse_id: item.id}).then (data) => @products = data

  #show chi tiết của sản phẩm dc chọn
  @clickTable = (item) =>
    Product.get('product_of',{product_code: item.productCode, skull_id: item.skull.id, warehouse_id: item.warehouseId}).then (data) => console.log data

  return
]