Sky.directive 'skySearch', ->
  obj =
    restrict: 'E'
    templateUrl: '../assets/directives/ui/select.html'
    scope:
      sourceUrl: '@'
      model: '='
      search: '='
      caption: '@'
      width: '@'
      change: '&'
