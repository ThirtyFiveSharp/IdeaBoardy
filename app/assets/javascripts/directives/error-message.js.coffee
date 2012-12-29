angular.module('idea-boardy')
  .directive 'errorMessage', ->
    (scope, element, attrs) ->
      ngModel = element.prev().controller('ngModel')
      return unless ngModel?
      element.addClass('error-message')
      ngModel.$parsers.push (viewValue) ->
        if ngModel.$dirty
          keys = _.keys ngModel.$error
          errorKeys = _.filter keys, (key) -> ngModel.$error[key]
          element.text errorKeys.join(' ')
        viewValue