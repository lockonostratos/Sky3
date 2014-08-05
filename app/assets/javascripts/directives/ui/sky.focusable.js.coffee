Sky.directive 'focusable', ->
  (scope, element, attrs) ->
    scope.$on 'focusable', (e, name) -> element[0].focus() if name is attrs.focusable
    return

Sky.factory 'focus', ['$rootScope', '$timeout', ($rootScope, $timeout) ->
  (name) ->
    $timeout -> $rootScope.$broadcast 'focusable', name
    return
]