Sky.directive 'skyButton', ->
  obj =
    restrict: 'E'
    templateUrl: '../assets/directives/ui/button.html'
    scope:
      caption: '@'
      icon: '@'
      rightIcon: '='
      color: '@'
      disabled: '='
      click: '&'

    controller: ($scope, $element, $attrs) ->
      $scope.hasIcon = $scope.icon isnt undefined
      $scope.hasCaption = $scope.caption isnt undefined

      $scope.colorClass = $scope.color ? 'sky'
      $scope.colorClass = 'sky shadow' if $scope.colorClass is 'shadow'
