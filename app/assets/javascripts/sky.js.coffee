#= require_self
#= require_tree ./controllers/global
#= require_tree ./services
#= require_tree ./filters

#= require_tree ./controllers/home
#= require_tree ./controllers/sales
#= require_tree ./controllers/warehouse

moment.lang 'vi'

window.Sky = angular.module 'Sky', ['ngRoute', 'rails', 'ui.bootstrap', 'ngAnimate', 'xeditable', 'dx']

Sky.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when('/', {
      templateUrl: '../assets/home/index.html'
      controller: 'Sky.indexCtrl'
    }).when('/sales', {
      templateUrl: '../assets/sales/home.html'
      controller: 'salesCtrl'
      controllerAs: 'salesCtrl'
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

