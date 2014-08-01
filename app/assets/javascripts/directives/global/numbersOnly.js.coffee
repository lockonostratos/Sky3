Sky.directive "onlyNum", ->
  (scope, element, attrs) ->
    keyCode = [8,9,37,39,48,49,50,51,52,53,54,55,56,57,96,97,98,99,100,101,102,103,104,105,110]
    element.bind "keydown", (event) ->
      console.log $.inArray(event.which, keyCode)
      if $.inArray(event.which, keyCode) is -1
        scope.$apply ->
          scope.$eval attrs.onlyNum
          event.preventDefault()
          return
        event.preventDefault()
      return
    return

Sky.directive 'numbersOnly', ->
  require: 'ngModel'
  link: (scope, element, attrs, modelCtrl) ->
    modelCtrl.$parsers.push (inputValue) ->
      return ""  if inputValue is `undefined`
      transformedInput = inputValue.replace(/[^0-9]/g, "")
      unless transformedInput is inputValue
        modelCtrl.$setViewValue transformedInput
        modelCtrl.$render()
      transformedInput
    return

