Sky.controller 'returnCtrl', ['focus', '$routeParams','$http', 'Common', 'Product', 'ProductSummary', 'Customer', 'MerchantAccount', 'TempOrder', 'TempOrderDetail', 'Order'
  (focus, $routeParams, $http, Common, Product, ProductSummary, Customer, MerchantAccount, TempOrder, TempOrderDetail, Order) ->
    Common.caption = 'giao hàng';


    return
]