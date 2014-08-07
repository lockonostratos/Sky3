#= require_self
#= require sky.system
#= require_tree ./controllers/global
#= require_tree ./services
#= require_tree ./filters
#= require_tree ./directives/ui

#= require_tree ./controllers/home
#= require_tree ./controllers/sales
#= require_tree ./controllers/warehouse

# require ng-focus-on

moment.lang 'vi'

window.Sky = angular.module 'Sky', ['ngRoute', 'rails', 'ui.bootstrap', 'ngAnimate', 'xeditable', 'dx', 'ui.utils']

Sky.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when('/', {
      templateUrl: '../assets/home/index.html'
      controller: 'Sky.indexCtrl'
    }).when('/sales', {
      templateUrl: '../assets/sales/home.html'
      controller: 'salesCtrl'
      controllerAs: 'salesCtrl'
    }).when('/sale', {
      templateUrl: '../assets/sales/sale.html'
      controller: 'saleCtrl'
      controllerAs: 'saleCtrl'
    }).when('/sale/delivery', {
      templateUrl: '../assets/sales/delivery.html'
      controller: 'deliveryCtrl'
      controllerAs: 'deliveryCtrl'
    }).when('/sale/return', {
      templateUrl: '../assets/sales/return.html'
      controller: 'returnCtrl'
      controllerAs: 'returnCtrl'
    }).when('/post/:postId',  {
      templateUrl: '../assets/home/post.html'
      controller: 'Sky.postCtrl'
    }).when('/warehouse/import', {
      templateUrl: '../assets/warehouse/import.html',
      controller: 'importCtrl'
      controllerAs: 'importCtrl'
    }).otherwise( {
      templateUrl: '../assets/global/404.html'
    })
]

Sky.run (editableOptions) -> editableOptions.theme = 'bs3'

Sky.gs = (name) -> angular.element(document.body).injector().get(name)

