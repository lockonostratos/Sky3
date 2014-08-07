Sky.directive 'skySelect', ->
  obj =
    restrict: 'E'
    templateUrl: '../assets/directives/ui/select.html'
    scope:
      options: '='
      model: '='
      caption: '@'
      color: '@'
      width: '@'
      change: '&'
      disabled: '='

    controller: ($scope, $element, $attrs) ->
      $scope.isOpen = false
      $scope.width ?= '200px'
      $scope.sizeStyle = "width: #{$scope.width}"
      $scope.colorClass = $scope.color ? 'sky'
      if $scope.colorClass is 'shadow' then $scope.colorClass = 'sky shadow'

      $scope.selectItem = (item) ->
        $scope.isOpen = false

        if $scope.model != item
          $scope.model = item
          $scope.change({model: item})

