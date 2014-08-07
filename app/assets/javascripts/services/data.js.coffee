#Sky.factory 'Product', ($resource)-> $resource 'api/products/:id', {id: '@id'}, {update: {method: 'PUT'}}

#Sky.factory "Product", ($resource) ->
#  $resource "/api/products/:id", { id: "@id" },
#    'create': { method: 'POST' }
#    'index': { method: 'GET', isArray: true }
#    'show': { method: 'GET', isArray: false }
#    'update': { method: 'PUT' }
#    'destroy': { method: 'DELETE' }

Sky.factory 'Session', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/sessions', name: 'session' }
]

Sky.factory 'Account', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/orders', name: 'account' }
]

Sky.factory 'MerchantAccount', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/merchant_accounts', name: 'merchantAccounts' }
]

Sky.factory 'Product', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/products', name: 'product' }
]

Sky.factory 'ProductSummary', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/product_summaries', name: 'productSummaries' }
]

Sky.factory 'Order', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/orders', name: 'order' }
]

Sky.factory 'Customer', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/customers', name: 'customer' }
]

Sky.factory 'TempOrder', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/temp_orders', name: 'tempOrder' }
]

Sky.factory 'TempOrderDetail', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/temp_order_details', name: 'temp_order_detail' }
]

Sky.factory 'TempImport', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/temp_imports', name: 'temp_import' }
]

Sky.factory 'TempImportDetail', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/temp_import_details', name: 'temp_import_details' }
]

Sky.factory 'Delivery', [ 'railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory { url: 'api/deliveries', name: 'delivery' }
]
