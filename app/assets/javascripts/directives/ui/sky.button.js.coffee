Sky.directive 'skyButton', ->
  obj =
    restrict: 'E'
    templateUrl: '../assets/directives/ui/button.html'
    scope:
      caption: '@'
      icon: '@'
      rightIcon: '='
      color: '@'

    controller: ($scope, $element, $attrs) ->
      $scope.hasIcon = $scope.icon != undefined
      $scope.colorClass = $scope.color ? 'sky'
      if $scope.colorClass is 'shadow' then $scope.colorClass = 'sky shadow'
