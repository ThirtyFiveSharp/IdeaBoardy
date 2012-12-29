angular.module('idea-boardy')
  .directive 'errorMessage', () ->
    require: '?ngModel'
    link: (scope, element, attrs, ngModelCtrl) ->
      return unless ngModelCtrl
      message = $ '<div class="error-message"></div>'
      message.click () ->
        message.detach()
        element.focus()
      ngModelCtrl.$parsers.push (viewValue) ->
        message.detach()
        if ngModelCtrl.$dirty and ngModelCtrl.$invalid
          errorKeys = _.filter(_.keys(ngModelCtrl.$error), (key) -> ngModelCtrl.$error[key])
          message.text(errorKeys.join(' ')).insertAfter(element)
            .width(element.width()).height(element.height()).offset(element.offset())
            .show()
        viewValue