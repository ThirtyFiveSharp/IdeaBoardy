angular.module('idea-boardy-services')
  .factory('dialog', ['autoUpdater', (autoUpdater) ->
    dialogs = {}
    class Dialog
      constructor: () ->
        @visible = false
        @context = {}
      open: (context) ->
        autoUpdater.pause()
        @context = context || {}
        @visible = true
      close: () ->
        autoUpdater.resume()
        @visible = false
      isOpen: () -> @visible
    (dialogName) ->
      dialog = dialogs[dialogName]
      dialogs[dialogName] = dialog = new Dialog if !dialog
      dialog
  ])