Sky.controller 'applicationCtrl', ['$routeParams', '$location', '$scope', 'Common', 'Session', 'MerchantAccount'
($routeParams, $location, $scope, Common, Session, MerchantAccount) ->
  Session.get('current_merchant_user').then (data) -> Common.currentMerchantAccount = data
  @Common = Common

  @showMenu = true
  @collapsedMode = false
  @name = 'Enterprise Dual Strategy'
  @currentUrl = $location.path()
  @navs = [
    active: true
    title: 'Tổng quan'
    url: '/'
    icon: 'fa fa-desktop'
  ,
    title: 'Bán hàng'
    url: '/sales'
    icon: 'fa fa-shopping-cart'
  ,
    title: 'Nhập kho'
    url: '/warehouse/import'
    icon: 'fa fa-download'
  ]

  @toggleCollapse = -> @collapsedMode = !@collapsedMode

  $scope.$on '$routeChangeSuccess', (e, current, previous) =>
    @currentUrl = current.originalPath

  return
]