angular.module('idea-boardy')
  .directive 'errorMessage', ['$timeout'
    ($timeout) ->
      require: 'ngModel'
      priority: -1
      link: (scope, element, attrs, ngModelCtrl) ->
        timeout = 200
        promiseToUpdateMessage = null
        messageText = $ '<span class="error-message-text"></span>'
        messageBox = $ '<div class="error-message"></div>'
        messageBox.append(messageText).bind 'click', (event) -> element.focus()
        messageUpdator = () ->
          prmise = null
          messageBox.detach()
          if ngModelCtrl.$dirty and ngModelCtrl.$invalid
            errorKeys = _.filter(_.keys(ngModelCtrl.$error), (key) -> ngModelCtrl.$error[key])
            messageText.text(errorKeys.join(' '))
            messageBox.insertAfter(element)
              .width(element.width()).height(element.height()).offset(element.offset())
              .show()
        ngModelCtrl.$parsers.push (viewValue) ->
          $timeout.cancel(promiseToUpdateMessage) if promiseToUpdateMessage?
          promiseToUpdateMessage = $timeout messageUpdator, timeout, false
          viewValue
  ]