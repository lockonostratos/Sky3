Sky.controller 'deliveryCtrl', ['focus', '$routeParams','$http', 'Common', 'Delivery'
  (focus, $routeParams, $http, Common, Delivery) ->
    Common.caption = 'giao hàng';

    Delivery.query().then (data) => console.log 'x'


    return
]