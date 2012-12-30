angular.module('idea-boardy')
  .directive('jqUi', -> (scope, element, attrs) -> element[attrs.jqUi].apply(element))
  .directive('jqUiDialog', ['dialog', (dialog) ->
    (scope, element, attrs) ->
      getRandomDialogName = -> "dialog_" + new Date().getTime()
      name = attrs.name or getRandomDialogName()
      options = JSON.parse(attrs.jqUiDialog or {})
      extendOptions =
        title: attrs.title
        autoOpen: false
        modal: true
        resizable: false
        show: 'fade'
        hide: 'fade'
        close: -> dialog(name).close()
      element.dialog(_.extend(options, extendOptions))
      scope.$watch ->
        needToOpen = dialog(name).visible
        if element.dialog('isOpen') isnt needToOpen
          event = dialog(name).context.$event or {}
          targetElement = event.currentTarget or window
          element.dialog('option', 'position', {of: targetElement})
            .dialog(if needToOpen then 'open' else 'close')
  ])