Sky.directive 'skyTab', ->
  obj =
    restrict: 'E'
    templateUrl: '../assets/directives/ui/tab.html'
    scope:
      options: '='
      model: '='
      caption: '@'
      change: '&'
      delete: '&'
      create: '&'

    controller: ($scope, $element, $attrs) ->
      $scope.colors = []
      $scope.model ?= $scope.options[0]

      $scope.selectTab = (item) ->
        if $scope.model != item
          $scope.model = item
          $scope.change({model: item})