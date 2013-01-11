angular.module('idea-boardy')
  .directive('jqUi', ['$parse', ($parse) ->
    link: (scope, element, attrs) -> element[attrs.jqUi].apply(element, $parse(attrs.args)(scope))
  ])
  .directive('jqUiDialog', ['dialog', (dialog) ->
    transclude: "element"
    priority: 1000
    terminal: true
    compile: (element, attr, transclude) ->
      (scope, iElement, iAttr) ->
        dialogScope = null
        dialogElement = null
        getRandomDialogName = () -> "dialog_" + new Date().getTime()
        name = iAttr.name or getRandomDialogName()
        options = JSON.parse(iAttr.jqUiDialog or {})
        defaultOptions =
          title: iAttr.title
          autoOpen: false
          modal: true
          resizable: false
          show: 'fade'
          hide: 'fade'
          close: () -> scope.$apply () -> dialog(name).close()
        watcher = () -> dialog(name).isOpen()
        listener = (visible) ->
          if visible
            dialogScope = scope.$new();
            event = dialog(name).context.$event or {}
            positionOption = {position: {of: event.target or window}}
            transclude dialogScope, (cloned) ->
              dialogElement = cloned.dialog(angular.extend({}, defaultOptions, options, positionOption)).dialog('open')
          else
            if(dialogElement?)
              dialogElement.dialog('close')
              dialogElement.remove()
              dialogElement = null
            if(dialogScope?)
              dialogScope.$destroy()
              dialogScope = null
        scope.$watch watcher, listener
  ])