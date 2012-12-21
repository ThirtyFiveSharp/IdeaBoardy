angular.module('idea-boardy')
  .factory('dialog', [() ->
    dialogs = {}
    class Dialog
      constructor: () ->
        @visible = false
        @context = {}
      open: (context) ->
        @context = context || {}
        @visible = true
      close: () ->
        @visible = false
    (dialogName) ->
      dialog = dialogs[dialogName]
      dialogs[dialogName] = dialog = new Dialog if !dialog
      dialog
  ])