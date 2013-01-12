angular.module('idea-boardy')
  .directive('errorMessage', ['$timeout', 'i18n'
    ($timeout, i18n) ->
      require: 'ngModel'
      priority: -1
      link: (scope, element, attrs, ngModelCtrl) ->
        timeout = 200
        lastErrorKeys = []
        messageBox = null
        promiseToUpdateMessage = null
        getErrorKey = (errorKeys) -> if errorKeys.length > 1 then 'invalid' else errorKeys[0]
        getErrorTooltip = (errorKeys) -> _.map(errorKeys, (key) -> i18n[key]).join(' ')
        messageUpdator = () ->
          errorKeys = _.filter(_.keys(ngModelCtrl.$error), (key) -> ngModelCtrl.$error[key])
          return if _.isEqual(lastErrorKeys, errorKeys)
          lastErrorKeys = errorKeys
          promiseToUpdateMessage = null
          messageBox.remove() if messageBox?
          messageBox = null
          return if ngModelCtrl.$valid
          messageText = $('<span class="error-message-text"></span>').text(getErrorKey(errorKeys)).attr('title', getErrorTooltip(errorKeys))
          messageBox = $ '<div class="error-message"></div>'
          messageBox.append(messageText).bind 'click', (event) -> element.focus()
          messageBox.insertAfter(element)
            .width(element.width()).height(element.height()).offset(element.offset())
            .show()
          messageText.tooltip({position: { my: "left+10 center", at: "right center", collision: "flipfit" }}).tooltip('open')
        ngModelCtrl.$parsers.push (viewValue) ->
          $timeout.cancel(promiseToUpdateMessage) if promiseToUpdateMessage?
          promiseToUpdateMessage = $timeout messageUpdator, timeout, false
          viewValue
  ])